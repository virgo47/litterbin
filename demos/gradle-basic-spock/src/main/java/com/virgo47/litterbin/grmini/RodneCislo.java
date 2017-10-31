package com.virgo47.litterbin.grmini;

/**
 * Resolver of variables f
 */
public class RodneCislo {

	private static final String RODNE_CISLO_REGEXP = "[0-9]{2}[0156][0-9][0-3][0-9]{4,5}";

	/**
	 * 10 digit birth number started on 1.1.1954.
	 */
	public static final int LONG_RC_FROM_YEAR = 1954;
	public static final int LONG_RC_LENGTH = 10;

	private final String rodneCislo;
	private final boolean valid;

	public RodneCislo(String rodneCislo) {
		this.rodneCislo = rodneCislo;
		valid = validate();
	}

	private boolean validate() {
		if (!rodneCislo.matches(RODNE_CISLO_REGEXP)) {
			return false;
		}

		// cislica 4: pripustne hodnoty 0-9 (ale ak cislica 3 je 0 alebo 5, tak cislica 4 nemoze byt 0)
		char mesiac1 = rodneCislo.charAt(2);
		char mesiac2 = rodneCislo.charAt(3);
		if ((mesiac1 == '0' || mesiac1 == '5') && mesiac2 == '0') {
			return false;
		}

		// cislica 6: pripustne hodnoty 0-9 (ale ak cislica 5 je 0, tak cislica 6 nemoze byt 0)
		char den1 = rodneCislo.charAt(4);
		char den2 = rodneCislo.charAt(5);
		if (den1 == '0' && den2 == '0') {
			return false;
		}

		if (rodneCislo.length() == 10
			&& !(Long.valueOf(rodneCislo) % 11 == 0)
			&& !(Long.valueOf(rodneCislo.substring(0, 9)) % 11 == 10
			&& rodneCislo.charAt(9) == '0'))
		{
			//ak je dlhe 10 cislic, tak:
			// 1. musi byt delitelne 11-timi
			//  alebo
			// 2. prvy 9 cislic musi po deleni 11-timi davat zvysok 10 a 10-ta cislica je 0
			return false;
		}
		if ("0156".indexOf(mesiac1) < 0) {
			return false;
		}
		if ("16".indexOf(mesiac1) >= 0 && mesiac2 > '2') {
			return false;
		}
		return true;

	}

	public boolean isValid() {
		return valid;
	}

	public String toString() {
		return rodneCislo;
	}
}
