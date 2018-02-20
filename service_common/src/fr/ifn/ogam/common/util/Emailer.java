package fr.ifn.ogam.common.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

/**
 * Allows the posting of mails.
 */
public class Emailer {

	// L'adresse du serveur STMP par défaut
	private static final String DEFAULT_STMP_HOST = "localhost";

	/**
	 * Get a Tomcat session context for mail.
	 * 
	 * @return a JNDI session
	 */
	public Session getTomcatSession() throws NamingException {

		Context initContext = new InitialContext();
		Session session = (Session) initContext.lookup("java:/comp/env/mail/Session");

		return session;
	}

	/**
	 * Creates a local session context.
	 * 
	 * @return a JNDI session
	 */
	public Session getStaticSession() throws Exception {

		Properties props = new Properties();
		props.put("mail.smtp.host", DEFAULT_STMP_HOST);
		Session session = Session.getDefaultInstance(props, null);
		session.setDebug(false);

		return session;
	}

	/**
	 * Sends an email with use of the JNDI configuration.
	 * 
	 * @param session
	 *            an open session on a SMTP server
	 * @param aFromEmailAddr
	 *            The address of the sender
	 * @param aFromName
	 *            the name of the sender
	 * @param aToEmailAddr
	 *            The address of the receiver. Separator semicolon for several destination address
	 * @param aSubject
	 *            The subject
	 * @param aBody
	 *            The content of the mail can be of type Exception or String
	 * @return true if everything is OK
	 */
	public boolean sendEmail(Session session, String aFromEmailAddr, String aFromName, String aToEmailAddr, String aSubject, Object aBody) throws Exception {

		MimeMessage message = new MimeMessage(session);

		message.setFrom(new InternetAddress(aFromEmailAddr, aFromName));

		// liste des destinataires
		String[] listdest = aToEmailAddr.split(";");
		InternetAddress[] internetAddresses = new InternetAddress[listdest.length];
		for (int a = 0; a < listdest.length; a++) {
			internetAddresses[a] = new InternetAddress(listdest[a]);
		}
		message.setRecipients(Message.RecipientType.TO, internetAddresses);
		// message.addRecipient(Message.RecipientType.TO, new InternetAddress(aToEmailAddr));

		message.setSubject(aSubject);

		String content = "";

		if (aBody instanceof Exception) {
			StringWriter sw = new StringWriter();
			PrintWriter s = new PrintWriter(sw);
			((Exception) aBody).printStackTrace(s);
			content = sw.toString();
		}
		if (aBody instanceof String) {
			content = (String) aBody;
		}

		message.setText(content);

		Transport.send(message);

		return true;

	}
}
