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
package fr.ifn.ogam.common.business;

/**
 * Represent a process of the Application.
 */
public class AbstractThread extends Thread {

	// We store the current status of the process
	private String taskName;
	private Integer currentCount;
	private Integer totalCount;

	// Ask for cancellation of the process
	private volatile boolean cancelled = false;

	/**
	 * @return the currentName
	 */
	public String getTaskName() {
		return taskName;
	}

	/**
	 * @param taskName
	 *            the taskName to set
	 */
	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	/**
	 * @return the currentCount
	 */
	public Integer getCurrentCount() {
		return currentCount;
	}

	/**
	 * @param currentCount
	 *            the currentCount to set
	 */
	public void setCurrentCount(Integer currentCount) {
		this.currentCount = currentCount;
	}

	/**
	 * @return the totalCount
	 */
	public Integer getTotalCount() {
		return totalCount;
	}

	/**
	 * @param totalCount
	 *            the totalCount to set
	 */
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

	/**
	 * Update the information about the current process.
	 * 
	 * @param name
	 *            The name of the current task
	 * @param current
	 *            The position in the current task
	 * @param total
	 *            The number of items in the current task
	 */
	public void updateInfo(String name, Integer current, Integer total) {
		setTaskName(name);
		setCurrentCount(current);
		setTotalCount(total);
	}

	/**
	 * @return the cancelled
	 */
	public boolean isCancelled() {
		return cancelled;
	}

	/**
	 * @param cancelled
	 *            the cancelled to set
	 */
	public void setCancelled(boolean cancelled) {
		this.cancelled = cancelled;
	}

}
