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
package fr.ifn.ogam.integration.servlet;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.Schemas;
import fr.ifn.ogam.common.database.metadata.FieldData;
import fr.ifn.ogam.common.database.metadata.FileFieldData;
import fr.ifn.ogam.common.database.metadata.FileFormatData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.TableTreeData;

/**
 * Meta Data Servlet.
 * 
 * Expose some services for the metadata.
 */
public class MetadataServlet extends HttpServlet {

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The serial version ID used to identify the object.
	 */
	protected static final long serialVersionUID = -123484792196121244L;

	/**
	 * The data access objects.
	 */
	private MetadataDAO metadataDAO = new MetadataDAO();

	/**
	 * Input parameters.
	 */

	private static final String ACTION = "action";
	private static final String ACTION_GET_REQUEST_FILES = "GetRequestFiles";
	private static final String ACTION_GET_FILE_FIELDS = "GetFileFields";
	private static final String ACTION_GET_TABLES_TREE = "GetTablesTree";
	private static final String ACTION_RESET_CACHE = "ResetCaches";

	private static final String REQUEST_ID = "REQUEST_ID";
	private static final String FILE_FORMAT = "FILE_FORMAT";
	private static final String TABLE_FORMAT = "TABLE_FORMAT";

	/**
	 * Main function of the servlet.
	 * 
	 * @param request
	 *            the request done to the servlet
	 * @param response
	 *            the response sent
	 */
	public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String action = null;

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		ServletOutputStream out = response.getOutputStream();

		try {
			logger.debug("Metadata servlet called");

			action = request.getParameter(ACTION);
			if (action == null) {
				throw new Exception("The " + ACTION + " parameter is mandatory");
			}

			//
			// Get the expected files for a request
			//
			if (action.equalsIgnoreCase(ACTION_GET_REQUEST_FILES)) {

				String requestId = request.getParameter(REQUEST_ID);
				if (requestId == null) {
					throw new Exception("The " + REQUEST_ID + " parameter is mandatory");
				}
				out.print(getRequestFiles(requestId));

			} else

			//
			// Get the fields of a data field
			//
				if (action.equalsIgnoreCase(ACTION_GET_FILE_FIELDS)) {

				String fileformat = request.getParameter(FILE_FORMAT);
				if (fileformat == null) {
					throw new Exception("The " + FILE_FORMAT + " parameter is mandatory");
				}

				out.print(getFileFields(fileformat));

			} else

			//
			// Reset the caches
			//
					if (action.equalsIgnoreCase(ACTION_RESET_CACHE)) {

				metadataDAO.clearCaches();

				out.print("Caches cleaned");

			} else

			//
			// Get the tree hierarchy of the table
			//
						if (action.equalsIgnoreCase(ACTION_GET_TABLES_TREE)) {

				String tableFormat = request.getParameter(TABLE_FORMAT);
				if (tableFormat == null) {
					throw new Exception("The " + TABLE_FORMAT + " parameter is mandatory");
				}

				out.print(getTablesTree(tableFormat));

			} else {
				throw new Exception("The action type is unknown");
			}

		} catch (Exception e) {
			logger.error("Error during data upload", e);
			out.print(e.getMessage());
		}
	}

	/**
	 * Return a JSON String listing the needed CSV files for a Dataset.
	 * 
	 * @param datasetId
	 *            the dataset identifier
	 * @return the list of requested files as a JSON string
	 */
	private String getRequestFiles(String datasetId) throws Exception {
		StringBuffer result = new StringBuffer();
		List<FileFormatData> requestList = metadataDAO.getDatasetFiles(datasetId);
		result.append("[");
		Iterator<FileFormatData> requestIter = requestList.iterator();
		while (requestIter.hasNext()) {
			FileFormatData requestedFile = requestIter.next();
			result.append("{format:\"" + requestedFile.getFormat() + "\",type:\"" + requestedFile.getFileType() + "\"}");
			if (requestIter.hasNext()) {
				result.append(",");
			}
		}
		result.append("]");
		return result.toString();
	}

	/**
	 * Return a JSON String listing the needed fields of a CSV File.
	 * 
	 * @param fileformat
	 *            the file format
	 * @return the list of fields in the file as a JSON string
	 */
	private String getFileFields(String fileformat) throws Exception {
		StringBuffer result = new StringBuffer();

		// Get the fields of the file format
		List<FileFieldData> fields = metadataDAO.getFileFields(fileformat);

		result.append("[");
		Iterator<FileFieldData> fieldsIter = fields.iterator();
		while (fieldsIter.hasNext()) {
			FieldData field = fieldsIter.next();
			result.append("{label:\"" + field.getData() + "\"}");
			if (fieldsIter.hasNext()) {
				result.append(",");
			}
		}
		result.append("]");
		return result.toString();
	}

	/**
	 * Return a JSON String listing the tables hierarchy.
	 * 
	 * @param tableFormat
	 *            the format of the root table
	 * @return the hierarchy of the parent tables as a JSON string
	 */
	private String getTablesTree(String tableFormat) throws Exception {
		StringBuffer result = new StringBuffer();

		// Get the fields of the file format
		List<TableTreeData> tables = metadataDAO.getTablesTree(tableFormat, Schemas.RAW_DATA);

		result.append("[");
		Iterator<TableTreeData> tablesIter = tables.iterator();
		while (tablesIter.hasNext()) {
			TableTreeData field = tablesIter.next();
			result.append("{table:\"" + field.getTable() + "\",parent:\"" + field.getParentTable() + "\"}");
			if (tablesIter.hasNext()) {
				result.append(",");
			}
		}
		result.append("]");
		return result.toString();
	}
}
