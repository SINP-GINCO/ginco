package fr.ifn.ogam.common.database.metadata;

/**
 * Describes a standard
 * @author rpas
 *
 */
public class StandardData {

	private String name ;
	
	private String label ;
	
	private String version ;
	
	/**
	 * Get name
	 * @return String the name
	 */
	public String getName() {
		return this.name ; 
	}
	
	/**
	 * Set name
	 * @param name
	 * @return
	 */
	public void setName(String name) {
		this.name = name ;
	}
	
	
	/**
	 * Get label
	 * @return String the label
	 */
	public String getLabel() {
		return this.label ;
	}
	
	/**
	 * Set label
	 * @param label
	 * @return
	 */
	public void setLabel(String label) {
		this.label = label ;
	}
	
	/**
	 * Get version
	 * @return String the version
	 */
	public String getVersion() {
		return this.version ;
	}
	
	/**
	 * Set version
	 * @param version
	 */
	public void setVersion(String version) {
		this.version = version ;
	}
}
