package hello;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

//import org.springframework.security.core.context.SecurityContextHolder;

@Controller
@EnableAutoConfiguration
@ComponentScan
public class SampleController {

	@Autowired
	private GreetingService greetingService;

	@RequestMapping("/")
	@ResponseBody
	String home() {
		greetingService.greet(UUID.randomUUID().toString());
		return "Hello World!";
	}

	@RequestMapping("/auth")
	@ResponseBody
	String auth() {
		return "Hello authenticated: " + SecurityContextHolder.getContext()
			.getAuthentication()
			.getName();
	}

	public static void main(String[] args) throws Exception {
		SpringApplication.run(SampleController.class, args);
	}
}
