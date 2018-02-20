package fr.ifn.ogam.common.util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

/**
 * Class containing several static functions used in the SIG operations.
 * 
 * @author sgalopin
 * 
 */
public class SIGUtils {

	// Control pattern for degrees format
	private static final String PATTERN = "[+\\-]?[0-9]{1,2}[.][0-9]{1,2}[.][0-9]{1,2}";

	/**
	 * Method used to convert the GPS WGS 84 coordinate from the degrees format to the decimal format. (+/-DD.MM.SS => +/-DD.dddddd)
	 * 
	 * Simple method without round parameters.
	 * 
	 * The rounding scale is set to 6 and the rounding mode to HALF_UP.
	 * 
	 * Example : DegreesToDecimals("47.13.55") return "47.231944".
	 * 
	 * @param coordinate
	 *            the coordinate in DMS
	 * @return A <code>String</code> containing the coordinate in the decimal format.
	 * @throws Exception
	 *             An exception is thrown if the coordinate don't match the degrees format
	 * 
	 */
	public static String degreesToDecimals(String coordinate) throws Exception {

		if (!Pattern.matches(PATTERN, coordinate)) {
			throw new Exception("The coordinates are invalids.");
		}

		String[] coordDMS = coordinate.split("\\.");

		int sign = 1;
		if (coordinate.startsWith("-")) {
			sign = -1;
		}

		int coordDegrees = Integer.parseInt(coordDMS[0].replace("+", "").replace("-", ""));
		double coordMinutes = Double.parseDouble(coordDMS[1]);
		double coordSecondes = Double.parseDouble(coordDMS[2]);
		double coordDecimal = sign * (coordDegrees + (coordMinutes + coordSecondes / 60) / 60);

		double roundedCoord = new BigDecimal(coordDecimal).setScale(6, BigDecimal.ROUND_HALF_UP).doubleValue();

		return String.valueOf(roundedCoord);
	}

}