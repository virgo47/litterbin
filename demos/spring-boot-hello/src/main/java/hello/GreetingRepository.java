package hello;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import hello.entity.Greeting;
import org.springframework.stereotype.Repository;

@Repository
public class GreetingRepository {

	@PersistenceContext
	private EntityManager entityManager;

	public Greeting save(Greeting greeting) {
		System.out.println("TRN in repository: " + entityManager.isJoinedToTransaction());
		entityManager.persist(greeting);
		return greeting;
	}
}
