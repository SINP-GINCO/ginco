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

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import fr.ifn.ogam.common.servlet.AbstractServlet;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;

/**
 * Abstract Upload Servlet.
 */
public abstract class AbstractUploadServlet extends AbstractServlet {

	/**
	 * The serial version ID used to identify the object.
	 */
	protected static final long serialVersionUID = -123484792196121293L;

	/**
	 * High level API for processing file uploads.
	 * 
	 * @see org.apache.commons.fileupload
	 * @see org.apache.commons.fileupload.servlet
	 */
	protected transient ServletFileUpload fileUpload;

	/**
	 * The factory used to store the file uploaded on the disk.
	 * 
	 * @see org.apache.commons.fileupload
	 * @see org.apache.commons.fileupload.disk
	 */
	protected transient DiskFileItemFactory fileItemFactory;

	/**
	 * The system file separator.
	 */
	protected final String separator = System.getProperty("file.separator");

	/**
	 * The upload path.
	 */
	protected String pathFileDirectory = null;

	/**
	 * Initializes servlet.
	 * 
	 * @throws ServletException
	 */
	public void init() throws ServletException {

		logger.debug("Start the Servlet initialisation...");

		try {

			// Read application parameters
			ApplicationParametersDAO parameterDAO = new ApplicationParametersDAO();
			pathFileDirectory = parameterDAO.getApplicationParameter("UploadDirectory");

			// Create a new file upload handler
			this.fileItemFactory = new DiskFileItemFactory();
			this.fileUpload = new ServletFileUpload(fileItemFactory);

			// Set the total max for a request size = 150 Mo
			long yourMaxRequestSize = 1024 * 1024 * 150;
			fileUpload.setSizeMax(yourMaxRequestSize);

		} catch (Exception e) {
			logger.error("Error while initialising servlet", e);

			throw new ServletException(e);
		}
		logger.debug("Servlet initialisation... OK");

	}

	/**
	 * Upload a file.
	 * 
	 * @param fileItem
	 *            a file
	 * @param fileName
	 *            the name of the destination file
	 */
	protected void uploadFile(FileItem fileItem, String fileName) throws Exception {
		InputStream sourceFile = null;
		OutputStream destinationFile = null;
		try {
			// GetName is used here for the files
			long sizeInBytes = fileItem.getSize();

			// Check if the file is stored on disk or in memory
			boolean writeToFile = (sizeInBytes > fileItemFactory.getSizeThreshold());

			// Create the file object
			File uploadedFile = new File(fileName);

			// Create the upload directory if needed
			String uploadPath = uploadedFile.getParent();
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				boolean dirWritten = uploadDir.mkdirs();
				if (!dirWritten) {
					throw new Exception("Error while creating the directory " + uploadPath);
				}
			}

			// Write data to disk
			if (writeToFile) {
				// Direct Record
				fileItem.write(uploadedFile);
				logger.debug("File Recorded in Direct Record mode : " + fileName);
			} else {
				// File is in memory, force the write on disk
				sourceFile = fileItem.getInputStream();
				destinationFile = new FileOutputStream(uploadedFile);

				byte[] buffer = new byte[512 * 1024];
				int nbLecture;
				while ((nbLecture = sourceFile.read(buffer)) != -1) {
					destinationFile.write(buffer, 0, nbLecture);
				}
				logger.debug("File Recorded in Streaming Record mode : " + fileName);
			}

		} catch (Exception e) {
			logger.error("Error while writing the file ", e);
			throw new FileUploadException("Error while writing the file to disk : " + e.getMessage());
		} finally {
			// Close the files
			if (sourceFile != null) {
				try {
					sourceFile.close();
				} catch (IOException ignored) {
					logger.error("Error while closing the file ", ignored);
				}
			}

			if (destinationFile != null) {
				try {
					destinationFile.close();
				} catch (IOException ignored) {
					logger.error("Error while closing the file ", ignored);
				}
			}

		}
	}

}
