/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 * 
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices. 
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents. 
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */
package fr.ifn.ogam.common.business.checks;
import java.util.*;

/**
 * Exception linked to a check.
 */
public class CheckExceptionArrayList extends Exception {


	// The check code array
	private ArrayList<CheckException> cea;
	
	/**
	 * Return the label corresponding to a code.
	 * 
	 * @param checkCode
	 *            the identifier of the check.
	 * @return the corresponding label.
	 */
	public ArrayList<CheckException> getCheckExceptionArrayList() {
		return cea;
	}

	/**
	 * Set the check identifier.
	 * 
	 * @param checkCode
	 *            the checkCode to set
	 */
	public void setCheckExceptionArrayList(ArrayList<CheckException> cea) {
		this.cea = cea;
	}

}
