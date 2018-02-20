package fr.ifn.ogam.common.util;

import javax.naming.spi.InitialContextFactory;
import javax.naming.Context;
import java.util.Hashtable;

/**
 * <p>
 * Title: SimpleContextFactory
 * </p>
 * <p>
 * Description: A very SimpleContextFactory to assist in JNDI lookups of SimpleDataSource
 * </p>
 * <p>
 * Copyright: Copyright (c) 2002
 * <p>
 * <p>
 * Company: JavaRanch
 * </p>
 * 
 * @author Carl Trusiak, Sheriff
 * @version 1.0
 */
public class SimpleContextFactory implements InitialContextFactory {

	private static SimpleContext instance;

	/**
	 * Method getInitialContext Returns the SimpleContext for use.
	 * 
	 * @param environment
	 * @return Context
	 */
	public synchronized Context getInitialContext(Hashtable environment) {

		if (instance == null) {
			instance = new SimpleContext();
		}
		return instance;
	}
}
