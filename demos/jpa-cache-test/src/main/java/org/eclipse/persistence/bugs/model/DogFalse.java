package org.eclipse.persistence.bugs.model;

import java.io.Serializable;

import javax.persistence.Cacheable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Cacheable(value = false)
public class DogFalse implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	private String name;

	public DogFalse() {
		// JPA
	}

	public DogFalse(String name) {
		this.name = name;
	}

	@Override public String toString() {
		return name;
	}
}
