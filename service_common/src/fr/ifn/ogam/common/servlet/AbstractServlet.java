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
package fr.ifn.ogam.common.servlet;

import java.util.Enumeration;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.AbstractThread;

/**
 * Abstract Servlet for the project.
 */
public abstract class AbstractServlet extends HttpServlet {

	protected static final String XMLHEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The serial version ID used to identify the object.
	 */
	protected static final long serialVersionUID = -123484792196121243L;

	/**
	 * Return an Error Message.
	 * 
	 * @param errorMessage
	 *            the error message
	 * @return the XML corresponding to the error message
	 */
	protected String generateErrorMessage(String errorMessage) {
		StringBuffer result = new StringBuffer(XMLHEADER);
		result.append("<Result>");
		result.append("<Status>KO</Status>");
		result.append("<ErrorMessage>" + errorMessage + "</ErrorMessage>");
		result.append("</Result>");
		return result.toString();
	}

	/**
	 * Return an Error Message with a code.
	 * 
	 * @param errorCode
	 *            the code of the error
	 * @param errorMessage
	 *            the error message
	 * @return the XML corresponding to the error message
	 */
	protected String generateErrorMessage(String errorCode, String errorMessage) {
		StringBuffer result = new StringBuffer(XMLHEADER);
		result.append("<Result>");
		result.append("<Status>KO</Status>");
		result.append("<ErrorCode>" + errorCode + "</ErrorCode>");
		result.append("<ErrorMessage>" + errorMessage + "</ErrorMessage>");
		result.append("</Result>");
		return result.toString();
	}

	/**
	 * Return a correct result.
	 * 
	 * @param value
	 *            the value to return
	 * @return the XML corresponding to the value
	 */
	protected String generateResult(String value) {
		StringBuffer result = new StringBuffer(XMLHEADER);
		result.append("<Result>");
		result.append("<Status>OK</Status>");
		result.append("<Value>" + value + "</Value>");
		result.append("</Result>");
		return result.toString();
	}

	/**
	 * Return a correct result plus some information about the status of the process.
	 * 
	 * @param value
	 *            the value to return
	 * @return the XML corresponding to the value
	 */
	protected String generateResult(String value, AbstractThread process) {
		StringBuffer result = new StringBuffer(XMLHEADER);
		result.append("<Result>");
		result.append("<Status>OK</Status>");
		result.append("<Value>" + value + "</Value>");
		result.append("<TaskName>" + process.getTaskName() + "</TaskName>");
		result.append("<CurrentCount>" + process.getCurrentCount() + "</CurrentCount>");
		result.append("<TotalCount>" + process.getTotalCount() + "</TotalCount>");
		result.append("</Result>");
		return result.toString();
	}

	/**
	 * Log the request parameters.
	 * 
	 * @param request
	 *            the HTTP request to log
	 */
	protected void logRequestParameters(HttpServletRequest request) {

		// Do not create a session !!!
		// 1) We don't need it because all servlets are called by the server (in the php code)
		// 2) it creates a new session on every call, which are not deleted, and lead to memory problems,
		//    especially with getStatus (1 request every second for each running import.

		/*HttpSession session = request.getSession();
		if (session == null) {
			logger.debug("Session is null");
		} else {
			logger.debug("Session id " + request.getSession().getId());
		}*/

		Enumeration paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String param = (String) paramEnum.nextElement();
			logger.debug("Parametre : " + param + "   valeur : " + request.getParameter(param));
		}

		Enumeration attribEnum = request.getAttributeNames();
		while (attribEnum.hasMoreElements()) {
			String param = (String) attribEnum.nextElement();
			logger.debug("Attribut : " + param + "   valeur : " + request.getAttribute(param));
		}
	}

}
