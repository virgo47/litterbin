package hello;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import hello.entity.Greeting;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GreetingService {

	@PersistenceContext
	private EntityManager entityManager;

	@Autowired
	private GreetingRepository greetingRepository;

	@Transactional
	public Greeting greet(String greetingMessage) {
		System.out.println("TRN in service: " + entityManager.isJoinedToTransaction());
		Greeting greeting = new Greeting();
		greeting.message = greetingMessage;
		return greetingRepository.save(greeting);
	}
}
