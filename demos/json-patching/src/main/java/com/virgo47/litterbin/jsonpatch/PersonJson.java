package com.virgo47.litterbin.jsonpatch;

import java.time.LocalDate;

public class PersonJson {

	public String name;

	public LocalDate birthdate;

	public String address;

	public String note;

	@Override
	public String toString() {
		return "PersonJson{" +
			"name='" + name + '\'' +
			", birthdate=" + birthdate +
			", address='" + address + '\'' +
			", note='" + note + '\'' +
			'}';
	}
}
