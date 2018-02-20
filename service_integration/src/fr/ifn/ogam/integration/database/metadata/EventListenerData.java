package fr.ifn.ogam.integration.database.metadata;

/**
 * Represent an event listener.
 */
public class EventListenerData {

	/**
	 * Identifier.
	 */
	private String id;

	/**
	 * Fully qualified class name.
	 */
	private String className;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the className
	 */
	public String getClassName() {
		return className;
	}

	/**
	 * @param className
	 *            the className to set
	 */
	public void setClassName(String className) {
		this.className = className;
	}

}
