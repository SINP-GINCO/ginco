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
package fr.ifn.ogam.common.database.checks;

/**
 * A Check.
 */
public class CheckData {

	/**
	 * The check identifier.
	 */
	private int checkId;

	/**
	 * The step of the check : CONFORMITY or COMPLIANCE.
	 */
	private String step;

	/**
	 * The name of the check.
	 */
	private String name;

	/**
	 * The label of the check.
	 */
	private String label;

	/**
	 * A description of what is checked.
	 */
	private String description;

	/**
	 * The SQL string corresponding to the check.
	 */
	private String statement;

	/**
	 * The level of the check (WARNING or ERROR).
	 */
	private String importance;

	/**
	 * @return the checkId
	 */
	public int getCheckId() {
		return checkId;
	}

	/**
	 * @param checkId
	 *            the checkId to set
	 */
	public void setCheckId(int checkId) {
		this.checkId = checkId;
	}

	/**
	 * @return the step
	 */
	public String getStep() {
		return step;
	}

	/**
	 * @param step
	 *            the step to set
	 */
	public void setStep(String step) {
		this.step = step;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name
	 *            the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the label
	 */
	public String getLabel() {
		return label;
	}

	/**
	 * @param label
	 *            the label to set
	 */
	public void setLabel(String label) {
		this.label = label;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description
	 *            the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the statement
	 */
	public String getStatement() {
		return statement;
	}

	/**
	 * @param statement
	 *            the statement to set
	 */
	public void setStatement(String statement) {
		this.statement = statement;
	}

	/**
	 * @return the importance
	 */
	public String getImportance() {
		return importance;
	}

	/**
	 * @param importance
	 *            the importance to set
	 */
	public void setImportance(String importance) {
		this.importance = importance;
	}

}
