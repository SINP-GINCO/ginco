package fr.ifn.ogam.common.util;

import javax.naming.Context;
import javax.naming.Name;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.NameParser;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

/**
 * A very thin Context for use by JNDIUnitTestHelper.
 * <p>
 * Copyright: Copyright (c) 2002
 * </p>
 * <p>
 * Company: JavaRanch
 * </p>
 * 
 * @author Carl Trusiak, Sheriff
 * @version 1.0
 */
public class SimpleContext implements Context {

	private Map<String, Object> table = new HashMap<String, Object>();

	/**
	 * Method lookup not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return Object
	 * @throws NamingException
	 */
	public Object lookup(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method lookup() not yet implemented.");
	}

	/**
	 * Method lookup Returns the SimpleDataSource.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return Object A copy of the SimpleDataSource class
	 * @throws NamingException
	 */
	public Object lookup(String name) throws NamingException {
		return table.get(name);
	}

	/**
	 * Method bind not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @param obj
	 *            The object to bind
	 * @throws NamingException
	 */
	public void bind(Name name, Object obj) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method bind() not yet implemented.");
	}

	/**
	 * Method bind the SimpleDataSource for use.
	 * 
	 * @param name
	 *            The JNDI name
	 * @param obj
	 *            The object to bind
	 * @throws NamingException
	 */
	public void bind(String name, Object obj) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		table.put(name, obj);
	}

	/**
	 * Method rebind not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @param obj
	 *            The object
	 * @throws NamingException
	 */
	public void rebind(Name name, Object obj) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method rebind() not yet implemented.");
	}

	/**
	 * Method rebind not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @param obj
	 * @throws NamingException
	 */
	public void rebind(String name, Object obj) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method rebind() not yet implemented.");
	}

	/**
	 * Method unbind not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @throws NamingException
	 */
	public void unbind(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method unbind() not yet implemented.");
	}

	/**
	 * Method unbind not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @throws NamingException
	 */
	public void unbind(String name) throws NamingException {
		table.remove(name);
	}

	/**
	 * Method rename not yet implemented.
	 * 
	 * @param oldName
	 *            The old JNDI name
	 * @param newName
	 *            The new JNDI name
	 * @throws NamingException
	 */
	public void rename(Name oldName, Name newName) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method rename() not yet implemented.");
	}

	/**
	 * Method rename not yet implemented.
	 * 
	 * @param oldName
	 *            The old JNDI name
	 * @param newName
	 *            The new JNDI name
	 * @throws NamingException
	 */
	public void rename(String oldName, String newName) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method rename() not yet implemented.");
	}

	/**
	 * Method list not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return NamingEnumeration
	 * @throws NamingException
	 */
	public NamingEnumeration list(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method list() not yet implemented.");
	}

	/**
	 * Method list not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return NamingEnumeration
	 * @throws NamingException
	 */
	public NamingEnumeration list(String name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method list() not yet implemented.");
	}

	/**
	 * Method listBindings not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return NamingEnumeration
	 * @throws NamingException
	 */
	public NamingEnumeration listBindings(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method listBindings() not yet implemented.");
	}

	/**
	 * Method listBindings not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return NamingEnumeration
	 * @throws NamingException
	 */
	public NamingEnumeration listBindings(String name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method listBindings() not yet implemented.");
	}

	/**
	 * Method destroySubcontext not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @throws NamingException
	 */
	public void destroySubcontext(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method destroySubcontext() not yet implemented.");
	}

	/**
	 * Method destroySubcontext not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @throws NamingException
	 */
	public void destroySubcontext(String name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method destroySubcontext() not yet implemented.");
	}

	/**
	 * Method createSubcontext not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return Context
	 * @throws NamingException
	 */
	public Context createSubcontext(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method createSubcontext() not yet implemented.");
	}

	/**
	 * Method createSubcontext not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return Context
	 * @throws NamingException
	 */
	public Context createSubcontext(String name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method createSubcontext() not yet implemented.");
	}

	/**
	 * Method lookupLink not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return Object
	 * @throws NamingException
	 */
	public Object lookupLink(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method lookupLink() not yet implemented.");
	}

	/**
	 * Method lookupLink not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return Object
	 * @throws NamingException
	 */
	public Object lookupLink(String name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method lookupLink() not yet implemented.");
	}

	/**
	 * Method getNameParser not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return NameParser
	 * @throws NamingException
	 */
	public NameParser getNameParser(Name name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method getNameParser() not yet implemented.");
	}

	/**
	 * Method getNameParser not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @return NameParser
	 * @throws NamingException
	 */
	public NameParser getNameParser(String name) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method getNameParser() not yet implemented.");
	}

	/**
	 * Method composeName not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @param prefix
	 * @return Name
	 * @throws NamingException
	 */
	public Name composeName(Name name, Name prefix) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method composeName() not yet implemented.");
	}

	/**
	 * Method composeName not yet implemented.
	 * 
	 * @param name
	 *            The JNDI name
	 * @param prefix
	 * @return String
	 * @throws NamingException
	 */
	public String composeName(String name, String prefix) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method composeName() not yet implemented.");
	}

	/**
	 * Method addToEnvironment not yet implemented.
	 * 
	 * @param propName
	 * @param propVal
	 * @return Object
	 * @throws NamingException
	 */
	public Object addToEnvironment(String propName, Object propVal) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method addToEnvironment() not yet implemented.");
	}

	/**
	 * Method removeFromEnvironment not yet implemented.
	 * 
	 * @param propName
	 * @return Object
	 * @throws NamingException
	 */
	public Object removeFromEnvironment(String propName) throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method removeFromEnvironment() not yet implemented.");
	}

	/**
	 * Method getEnvironment not yet implemented.
	 * 
	 * @return Hashtable
	 * @throws NamingException
	 */
	public Hashtable getEnvironment() throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method getEnvironment() not yet implemented.");
	}

	/**
	 * Method close not yet implemented.
	 * 
	 * @throws NamingException
	 */
	public void close() throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method close() not yet implemented.");
	}

	/**
	 * Method getNameInNamespace not yet implemented.
	 * 
	 * @return String
	 * @throws NamingException
	 */
	public String getNameInNamespace() throws NamingException {

		/**
		 * @todo: Implement this javax.naming.Context method
		 */
		throw new java.lang.UnsupportedOperationException("Method getNameInNamespace() not yet implemented.");
	}
}
