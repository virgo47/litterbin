package com.virgo47.litterbin.jsonpatch;

import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class JsonPatch {

	public static void main(String[] args) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		mapper.registerModule(new JavaTimeModule());
		mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

		PersonJson object = mapper.readValue("{" +
			"\"name\": \"Virgo\", \"birthdate\": \"2000-02-16\", \"address\": \"some\"" +
			"}", PersonJson.class);

		System.out.println("object = " + object);

		String patch = "{\"birthdate\": \"1999-02-16\", \"note\": \"New note\", \"address\": null}";

		JsonNode patchObject = mapper.readTree(patch);
		System.out.println("JsonNode patch = " + patchObject);
		System.out.println("Patch as object = " + mapper.treeToValue(patchObject, PersonJson.class));

		Map<String, Object> map = mapper.readValue(patch, new TypeReference<Map<String, String>>(){});
		System.out.println("map = " + map);


		mapper.updateValue(object, map);
		System.out.println("UPDATED object = " + object);
		mapper.updateValue(object, map);
		System.out.println("Idempotency test:" + object);
	}
}
