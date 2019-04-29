# SQL trees and hierarchies

Following experiments are made with H2 syntax.

## Using tree table

Let's have a table with hierarchical items:
```sql
CREATE TABLE ITEM (
	ID IDENTITY PRIMARY KEY,
	CODE VARCHAR2(20 CHAR),
	DESCRIPTION TEXT,
	PARENT_ID BIGINT,

	FOREIGN KEY (PARENT_ID) REFERENCES ITEM(ID)
);
```

Let's say we have the following data in the table:
```
insert into ITEM (ID, CODE, PARENT_ID) values
(1, 'ROOT', null),
(2, 'LEFT', 1),
(3, 'RIGHT', 1),
(4, 'LL', 2),
(5, 'LM', 2),
(6, 'LR', 2),
(7, 'R', 3),
(8, 'R2', 7),
(9, 'R3', 8)
```

To define and fill up a "tree" table containing all nodes (CHILD_ID) under another node (ROOT_ID):
```sql
CREATE TABLE ITEM_TREE (
	ROOT_ID BIGINT NOT NULL,
	CHILD_ID BIGINT NOT NULL,

	PRIMARY KEY (ROOT_ID, CHILD_ID)
);

-- this also inserts "identity" rows where parent_id=child_id
INSERT INTO ITEM_TREE (ROOT_ID, CHILD_ID)
WITH tree
  (ROOT_ID, CHILD_ID)
AS (
  SELECT ID, ID FROM ITEM
  -- or to create tree without identity rows:
  --SELECT PARENT_ID, ID FROM ITEM WHERE PARENT_ID IS NOT NULL  
  UNION ALL
  SELECT tree.ROOT_ID, child.ID
    FROM tree
    INNER JOIN ITEM child on child.PARENT_ID=tree.CHILD_ID
)
SELECT ROOT_ID, CHILD_ID
FROM tree
;
```

Whether to use identity rows depends mostly on applications and expected results form queries.
The `WHERE` part of the initial query is not necessary and has the following effects:

* With `WHERE PARENT_ID IS NOT NULL` we not get the top root in `CHILD_ID` column,
but there will be no `NULL`s in `ROOT_ID` column.

* Without the `WHERE` we will have `NULL`s in `ROOT_ID` and we can select the whole tree with
`WHERE ROOT_ID IS NULL` and we will also have ID of the top root in `CHILD_ID` (one row).

Examples of queries utilizing the tree table:
```sql
-- select everything under 3 (including 3 depending on the presence of identity rows)
select * from item i
  join item_tree it on it.child_id=i.id
  where it.root_id=3;

-- select all the ancestors (parents recursively) above item with id 8
select * from item i
  join item_tree it on it.root_id=i.id
  where it.child_id=8  
```

## Using CTE select directly

The same thing can be executed without prepared tree table using the [Common Table Expression (CTE)](https://en.wikipedia.org/wiki/Hierarchical_and_recursive_queries_in_SQL#Common_table_expression)
contained in the INSERT clause above - like so:
```sql
-- this time the version without identity rows
WITH tree
  (ROOT_ID, CHILD_ID)
AS (
  SELECT PARENT_ID, ID FROM ITEM WHERE PARENT_ID IS NOT NULL  
  UNION ALL
  SELECT tree.ROOT_ID, child.ID
    FROM tree
    INNER JOIN ITEM child on child.PARENT_ID=tree.CHILD_ID
)
SELECT ROOT_ID, CHILD_ID
FROM tree
WHERE CHILD_ID=8
;
```

## Adding level?

It does NOT make sense to add absolute level to the tree table - is it level of child or root?
This can be clarified with column name (like `CHILD_LEVEL`) but why would many items have the same
information about level?

Absolute level belongs to the original `ITEM` table if it's required.
Also sometimes we join by `CHILD_ID` and sometimes by `ROOT_ID` depending on whether we want
ancestors or subtree - but what if we join by `ROOT_ID` and want its level?
With the absolute level on the `ITEM` table this is not a problem however we join.

What we can do though is add level-difference information:

TODO

## Populating existing table with `tree_path` column

We may want some "path" column based on IDs separated by a dot.
The content of the new column may be obtained like this:
```sql
with link(id, path) as (
  select id, id || '.' from item where parent_id is null
  union all
  select child.id, link.path || child.id || '.'
    from link inner join item child on link.id = child.parent_id
)
select id, path from link order by path
```

The trailing dot is intentional for reasons explained later around queries.
Let's add and populate the column:
```sql
-- text is probably overkill, but we don't care here
alter table item add tree_path text;

update item item_updated set
  item_updated.tree_path = (
    with link(id, path) as (
      select id, id || '.' from item where parent_id is null
      union all
      select child.id, link.path || child.id || '.'
        from link inner join item child on link.id = child.parent_id
    )
    select path from link
    where id = item_updated.id
  )
```

We can then use it to select all children or parents like this:
```sql
-- children including the node itself, we use the path='1.2.' of the node id=4
select * from item where tree_path like '1.2.%'
-- exluding the node uses AND
select * from item where tree_path like '1.2.%' and id != 4
-- if we don't know the path, we have to join or subselect
-- in that case tree table may be better as it uses only PK/FK, not strings

-- ancestors
select * from item where '1.3.7.8.' like tree_path || '%'  
-- excluding itself
select * from item where '1.3.7.8.' like tree_path || '%' and id != 8  
```

## Checking hierarchy levels and tree path format

```sql
-- tree_path format - must end with the dot
select * from item
where tree_path not like '%.'
;

-- check of the tree_path of the item and its parent
select parent.tree_path || i.id || '.', i.TREE_PATH, i.* from item i
left join item parent on parent.id = ak.parent_id
where i.tree_path <> parent.tree_path || i.id || '.'
;

-- check of the level of the item and its parent
select i.id
from item i
left join item parent on parent.id = i.parent_id
where i.lvl - 1 <> parent.lvl
;

-- check of the level and number of dots in the tree_path
select * from item
where lvl <> (length(translate(tree_path, '.0123456789', '.')) - 1)
;

-- fix of lvl
update item
set lvl=(length(translate(tree_path, '.0123456789', '.')) - 1)
where lvl <> (length(translate(tree_path, '.0123456789', '.')) - 1)
```
