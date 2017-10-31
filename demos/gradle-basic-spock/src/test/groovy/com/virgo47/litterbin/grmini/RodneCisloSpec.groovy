package com.virgo47.litterbin.grmini

import spock.lang.Specification

class RodneCisloSpec extends Specification {

	def "Platné rodné číslo s 10 miestami."() {
		expect:
		new RodneCislo("7911047474").isValid()
	}
}
