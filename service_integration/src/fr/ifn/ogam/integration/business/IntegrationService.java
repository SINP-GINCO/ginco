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
package fr.ifn.ogam.integration.business;

import static fr.ifn.ogam.common.business.UnitTypes.DATE;
import static fr.ifn.ogam.common.business.UnitTypes.TIME;
import static fr.ifn.ogam.common.business.checks.CheckCodes.NO_MAPPING;
import static fr.ifn.ogam.common.business.checks.CheckCodes.UNEXPECTED_SQL_ERROR;
import static fr.ifn.ogam.common.business.checks.CheckCodes.WRONG_FIELD_NUMBER;
import static fr.ifn.ogam.common.business.checks.CheckCodes.WRONG_FILE_FIELD_CSV_LABEL;
import static fr.ifn.ogam.common.business.checks.CheckCodes.DUPLICATED_FILE_LABEL;
import static fr.ifn.ogam.common.business.checks.CheckCodes.NO_DATA_IN_FILE;
import static fr.ifn.ogam.common.business.checks.CheckCodes.MANDATORY_HEADER_LABEL_MISSING;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.AbstractThread;
import fr.ifn.ogam.common.business.Data;
import fr.ifn.ogam.common.business.GenericMapper;
import fr.ifn.ogam.common.business.MappingTypes;
import fr.ifn.ogam.common.business.Schemas;
import fr.ifn.ogam.common.business.UnitTypes;
import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.business.checks.CheckExceptionArrayList;
import fr.ifn.ogam.common.database.GenericDAO;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.metadata.FileFieldData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.TableFieldData;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.rawdata.SubmissionDAO;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;
import fr.ifn.ogam.common.util.CSVFile;
import fr.ifn.ogam.common.util.InconsistentNumberOfColumns;
import fr.ifn.ogam.integration.database.rawdata.CheckErrorDAO;

/**
 * This service manages the integration process.
 */
public class IntegrationService extends GenericMapper {

	/**
	 * The logger used to log the errors or several information.
	 *
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The database accessors.
	 */
	private MetadataDAO metadataDAO = new MetadataDAO();
	private GenericDAO genericDAO = new GenericDAO();
	private CheckErrorDAO checkErrorDAO = new CheckErrorDAO();
	private SubmissionDAO submissionDAO = new SubmissionDAO();
	private ApplicationParametersDAO parameterDao = new ApplicationParametersDAO();

	/**
	 * Number of errors for a submission
	 */
	private Integer totalImportError = null;

	/**
	 * Error limit number for a submission
	 */
	private Integer limitImportError = null;

	/**
	 * Event notifier
	 */
	private IntegrationEventNotifier eventNotifier = new IntegrationEventNotifier();

	/**
	 * Insert a dataset coming from a CSV in database. First this function do the checks line by line Then, if no error has been found in the whole file, do the
	 * insert line by line
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @param userSrid
	 *            the srid given by the user
	 * @param filePath
	 *            the source data file path
	 * @param userExtension
	 *            the extension given by the user
	 * @param sourceFormat
	 *            the source format identifier
	 * @param requestParameters
	 *            the static values (PROVIDER_ID, DATASET_ID, SUBMISSION_ID, ...)
	 * @param thread
	 *            the thread that is running the process (optionnal, this is too keep it informed of the progress)
	 * @return the status of the update
	 */
	public boolean insertData(Integer submissionId, Integer userSrid, String filePath, String userExtension, String sourceFormat, String fileType,
			Map<String, String> requestParameters, AbstractThread thread) throws Exception {

		logger.debug("insertData");
		totalImportError = new Integer(0);
		limitImportError = Integer.valueOf(parameterDao.getApplicationParameter("limit_import_error"));
		CSVFile csvFile = null;
		int row = 0;
		String[] csvLine = null;

		/*
		 * Insert Information file without Lines We want to keep the file name Change sourceFormat instead of fileType to avoid duplicate in case of multifiles
		 */
		submissionDAO.addSubmissionFile(submissionId, sourceFormat, filePath, 0);

		try {
			List<FileFieldData> CSVsourceFieldDescriptors = null;

			// Parse the CSV file
			try {
				csvFile = new CSVFile(filePath);
			} catch (InconsistentNumberOfColumns ince) {
				// The file number of columns changes from line to line
				CheckException ce = new CheckException(WRONG_FIELD_NUMBER);
				ce.setSourceFormat(sourceFormat);
				ce.setSubmissionId(submissionId);
				throw ce;
			}

			// Check that the file is not empty
			if (csvFile.getRowsCount() == 0) {
				return true;
			}

			//--  Get the description of the content of the CSV file and check the header (first line)

			csvLine = csvFile.readNextLine();
			if (csvLine != null) {
				try {
					CSVsourceFieldDescriptors = getFileFieldsFromCSV(csvLine, sourceFormat, submissionId, sourceFormat, csvFile.getCurrentLine());
				} catch (Exception e) {
					// Some csv labels are not present in file_format, or are duplicated, or mandatory fields are missing
					return false;
				}
			}

			// Update line_number for the submissionId after a correct test on file.
			// Remove the header line in the row count
			submissionDAO.updateSubmissionFile(submissionId, csvFile.getRowsCount() - 1);

			// Get the destination formats
			Map<String, TableFormatData> destFormatsMap = metadataDAO.getFormatMapping(sourceFormat, MappingTypes.FILE_MAPPING);

			// Prepare the storage of the description of the destination tables
			Map<String, Map<String, TableFieldData>> tableFieldsMap = new HashMap<String, Map<String, TableFieldData>>();

			// Get the description of the destination tables
			Iterator<TableFormatData> destFormatIter = destFormatsMap.values().iterator();
			while (destFormatIter.hasNext()) {
				TableFormatData destFormat = destFormatIter.next();

				// Get the list of fields for the table
				// TODO : Filter on the dataset fields only (+ common fields like provider_id)
				Map<String, TableFieldData> destFieldDescriptors = metadataDAO.getTableFields(destFormat.getFormat());

				// Store in a map
				tableFieldsMap.put(destFormat.getFormat(), destFieldDescriptors);
			}

			// Get the field mapping
			// We create a map, giving for each field name a descriptor with the name of the destination table and column.
			Map<String, TableFieldData> mappedFieldDescriptors = metadataDAO.getFileToTableMapping(sourceFormat);

			// Prepare the common destination fields for each table (indexed by destination format)
			Map<String, GenericData> commonFieldsMap = new HashMap<String, GenericData>();

			// We go thru the expected destination fields of each table
			destFormatIter = destFormatsMap.values().iterator();
			while (destFormatIter.hasNext()) {
				TableFormatData destFormat = destFormatIter.next();

				Map<String, TableFieldData> destFieldDescriptors = tableFieldsMap.get(destFormat.getFormat());

				Iterator<String> destDescriptorIter = destFieldDescriptors.keySet().iterator();
				while (destDescriptorIter.hasNext()) {
					String sourceData = destDescriptorIter.next();
					TableFieldData destFieldDescriptor = destFieldDescriptors.get(sourceData);

					// If the field is not in the mapping
					TableFieldData destFound = mappedFieldDescriptors.get(sourceData);
					if (destFound == null) {

						// We look in the request parameters for the missing field
						String value = requestParameters.get(destFieldDescriptor.getData());
						if (value != null) {

							// We create the metadata for a virtual source file
							FileFieldData fieldData = new FileFieldData();
							fieldData.setData(destFieldDescriptor.getData());
							fieldData.setFormat(destFieldDescriptor.getFormat());
							fieldData.setType(destFieldDescriptor.getType());
							fieldData.setSubtype(destFieldDescriptor.getSubtype());
							fieldData.setUnit(destFieldDescriptor.getUnit());
							fieldData.setIsMandatory(true);

							// We add it to the common fields
							GenericData commonField = new GenericData();
							commonField.setFormat(destFieldDescriptor.getData());
							commonField.setColumnName(destFieldDescriptor.getColumnName());
							commonField.setType(fieldData.getType());
							commonField.setValue(convertType(fieldData, value));
							commonFieldsMap.put(commonField.getFormat(), commonField);
						}
					}
				}
			}

			// -- Checks Step --
			// Travel the content of the csv file line by line (after the first one) to perform the checks
			// format checks and custom checks
			row = 1;
			csvLine = csvFile.readNextLine();
			while (csvLine != null) {

				// Very important !!! Reset between each line
				Map<String, GenericData> fieldsMap = new HashMap<String, GenericData>();
				fieldsMap.putAll(commonFieldsMap);

				try {
					if (thread != null) {
						thread.updateInfo("Checking " + sourceFormat + " data", row, csvFile.getRowsCount());
						if (thread.isCancelled()) {
							return false; // don't finish the job
						}
					}

					// Store each column in the destination table container
					for (int col = 0; col < csvFile.getColsCount(); col++) {

						// Get the value to insert
						String value = csvLine[col];

						// The value once transformed into an Object
						Object valueObj = null;

						// Get the field descriptor
						FileFieldData sourceFieldDescriptor = CSVsourceFieldDescriptors.get(col);
						if(value.isEmpty() && (sourceFieldDescriptor.getDefaultValue() != null)) {   
							value =  sourceFieldDescriptor.getDefaultValue();
						}
						
						// Check the mask if available and the variable is not a date (date format is tested with a date format)
						if (sourceFieldDescriptor.getMask() != null && !sourceFieldDescriptor.getType().equalsIgnoreCase(DATE)
								&& !sourceFieldDescriptor.getType().equalsIgnoreCase(TIME)) {
							try {
								checkMask(sourceFieldDescriptor.getMask(), value);
							} catch (CheckException ce) {
								// Complete the description of the problem
								ce.setExpectedValue(sourceFieldDescriptor.getMask());
								ce.setFoundValue(value);
								logger.debug("setFoundValue value: " + value);
								ce.setSourceData(sourceFieldDescriptor.getData());
								totalImportError = addError(submissionId, sourceFormat, ce, csvFile.getCurrentLine());
							}
						}

						// *Check* and convert the type
						try {
							valueObj = convertType(sourceFieldDescriptor, value);
						} catch (CheckException ce) {
							// Complete the description of the problem
							ce.setSourceFormat(sourceFormat);
							ce.setSourceData(sourceFieldDescriptor.getData());
							ce.setFoundValue(value);
							if (ce.getExpectedValue() == null) {
								ce.setExpectedValue(sourceFieldDescriptor.getType());
							}
							totalImportError = addError(submissionId, sourceFormat, ce, csvFile.getCurrentLine());
						}

						// Get the mapped column destination
						TableFieldData mappedFieldDescriptor = mappedFieldDescriptors.get(sourceFieldDescriptor.getData());

						if (mappedFieldDescriptor == null) {
							CheckException ce = new CheckException(NO_MAPPING);
							ce.setFoundValue(sourceFieldDescriptor.getData());
							totalImportError = addError(submissionId, sourceFormat, ce, csvFile.getCurrentLine());
						}

						// Create the descriptor of the data
						GenericData data = new GenericData();
						data.setFormat(mappedFieldDescriptor.getFormat());
						data.setColumnName(mappedFieldDescriptor.getColumnName());
						data.setType(sourceFieldDescriptor.getType());
						data.setValue(valueObj);

						// Store the descriptor in the list
						fieldsMap.put(mappedFieldDescriptor.getData(), data);
					}

					try {
						// Notify the event listeners that checks are performed
						eventNotifier.checkLine(submissionId, fieldsMap);
					} catch (CheckException ce) {
						totalImportError = addError(submissionId, sourceFormat, ce, csvFile.getCurrentLine());
					} catch (CheckExceptionArrayList ceal) {
						// Catch the errors from ChecksDSRGinco and write them
						ArrayList<CheckException> alce = ceal.getCheckExceptionArrayList();
						for (int c = 0; c < alce.size(); c++) {
							totalImportError = addError(submissionId, sourceFormat, alce.get(c), csvFile.getCurrentLine());
						}
					} catch (Exception e) {
						throw e;
					}

				} catch (CheckException ce) {
					// Line-Level catch of checked exceptions
					if (totalImportError < limitImportError) {
						totalImportError = totalImportError + 1;
						logger.error("CheckException", ce);
						// We store the check exception in database
						checkErrorDAO.createCheckError(ce);
					} else {
						throw ce;
					}
				}
				// continue to the next line
				csvLine = csvFile.readNextLine();
				row++;
			}
			//1005
			if (row == 1) {
				CheckException ce = new CheckException(NO_DATA_IN_FILE);
				ce.setSourceFormat(sourceFormat);
				ce.setSubmissionId(submissionId);
				throw ce;				
			}
			

			// -- Insertion Step --
			// Do the insert if no error has been found before
			if (totalImportError == 0) {
				// Restart the reading of the csv from its beginning
				csvFile.reset();
				// Skip the header : we do not want to insert it
				csvLine = csvFile.readNextLine();
				row = 1;
				csvLine = csvFile.readNextLine();
				while (csvLine != null) {

					// Very important !!! Reset between each line
					Map<String, GenericData> fieldsMap = new HashMap<String, GenericData>();
					fieldsMap.putAll(commonFieldsMap);

					try {
						if (thread != null) {
							thread.updateInfo("Inserting " + sourceFormat + " data", row, csvFile.getRowsCount());
							if (thread.isCancelled()) {
								return false; // don't finish the job
							}
						}

						// List of tables where to insert data
						Set<String> tablesContent = new TreeSet<String>();

						// Get the destination table of each csv column
						for (int col = 0; col < csvFile.getColsCount(); col++) {
							// Get the field descriptor
							FileFieldData sourceFieldDescriptor = CSVsourceFieldDescriptors.get(col);
							// Get the mapped column destination
							TableFieldData mappedFieldDescriptor = mappedFieldDescriptors.get(sourceFieldDescriptor.getData());
							// Store the name of the table
							tablesContent.add(mappedFieldDescriptor.getFormat());

							// Get the value to insert
							String value = csvLine[col];
							// The value once transformed into an Object
							Object valueObj = null;
							if(value.isEmpty() && (sourceFieldDescriptor.getDefaultValue() != null)) {   
								value =  sourceFieldDescriptor.getDefaultValue();
							}
							if(value.isEmpty() && (mappedFieldDescriptor.getDefaultValue() != null)) {   
								value =  mappedFieldDescriptor.getDefaultValue();
							}
							// Check - once again, but it's ok, it's been checked before - and convert the type
							valueObj = convertType(sourceFieldDescriptor, value);

							// Create the descriptor of the data
							GenericData data = new GenericData();
							data.setFormat(mappedFieldDescriptor.getFormat());
							data.setColumnName(mappedFieldDescriptor.getColumnName());
							data.setType(sourceFieldDescriptor.getType());
							data.setValue(valueObj);
							

							// Store the descriptor in the list
							fieldsMap.put(mappedFieldDescriptor.getData(), data);
						}

						// Insert the content of the line in the destination tables
						Iterator<String> tablesIter = tablesContent.iterator();
						while (tablesIter.hasNext()) {
							String format = tablesIter.next();

							// Get the destination table name
							TableFormatData destTable = destFormatsMap.get(format);
							String tableName = destTable.getTableName();

							try {
								// Increment the line number
								GenericData lineNumber = new GenericData();
								lineNumber.setColumnName(Data.LINE_NUMBER);
								lineNumber.setType(UnitTypes.INTEGER);
								lineNumber.setFormat(Data.LINE_NUMBER);
								lineNumber.setValue(csvFile.getCurrentLine());
								// Complete the description of the line
								fieldsMap.put(Data.LINE_NUMBER, lineNumber);

								// Notify the event listeners that a line is going to be inserted (values in fieldsMap may be updated)
								eventNotifier.beforeLineInsertion(submissionId, fieldsMap);

								// Insert the list of values in the destination table
								String id = genericDAO.insertData(Schemas.RAW_DATA, format, tableName, tableFieldsMap.get(format), fieldsMap, userSrid);

								// Notify the event listeners that a line has been inserted
								eventNotifier.afterLineInsertion(submissionId, format, tableName, fieldsMap, id);

							} catch (CheckException ce) {
								totalImportError = addError(submissionId, sourceFormat, ce, csvFile.getCurrentLine());
							}
						}

					} catch (CheckException ce) {
						// Line-Level catch of checked exceptions
						if (totalImportError < limitImportError) {
							totalImportError = totalImportError + 1;
							logger.error("CheckException", ce);
							// We store the check exception in database and continue to the next line
							checkErrorDAO.createCheckError(ce);
						} else {
							throw ce;
						}
					}
					// Continue to next line
					csvLine = csvFile.readNextLine();
					row++;
				}
			}

			// Replace extension to print the right one in jdd table
			if (userExtension.equals(".zip")) {
				submissionDAO.updateSubmissionFileName(submissionId, filePath.replaceAll(".csv", ".zip"));
			}
			
			// Indicate insert step is over, post import computations are running
			if (thread != null) {
				thread.updateInfo("Computing " + sourceFormat + " data", row, csvFile.getRowsCount());
				if (thread.isCancelled()) {
					return false; // don't finish the job
				}
			}
			
		} catch (

		CheckException ce) {
			if (totalImportError < limitImportError) {
				// File-Level catch of checked exceptions
				totalImportError = totalImportError + 1;
				ce.setSourceFormat(sourceFormat);
				ce.setSubmissionId(submissionId);
				logger.error("CheckException", ce);

				// Store the check exception in database
				checkErrorDAO.createCheckError(ce);
			}
		} catch (Exception e) {
			// File-Level catch of unexpected exceptions
			totalImportError = totalImportError + 1;
			CheckException ce = new CheckException(UNEXPECTED_SQL_ERROR);
			ce.setSourceFormat(sourceFormat);
			ce.setSubmissionId(submissionId);
			logger.error("Unexpected Exception", e);

			// Store the check exception in database
			checkErrorDAO.createCheckError(ce);

		} finally {
			if (csvFile != null) {
				csvFile.close();
			}
		}

		return totalImportError == 0;

	}

	/**
	 * Get the description of the fields of a CSV File. Check the header.
	 *
	 * @param csvLine
	 *            the header (first line) of the file
	 *
	 * @param fileFormat
	 *
	 * @param submissionId
	 *
	 * @param sourceFormat
	 *
	 * @return the list of field descriptors
	 *
	 * @throws Exception
	 *             in case of error
	 */
	public List<FileFieldData> getFileFieldsFromCSV(String[] csvLine, String fileFormat, Integer submissionId, String sourceFormat, Integer currentLine)
			throws Exception {

		List<FileFieldData> CSVsourceFieldDescriptors = new ArrayList<FileFieldData>();
		FileFieldData field = null;
		boolean isHeaderValid = true;

		/* Check there is no unexpected column label in the header */
		for (int col = 0; col < csvLine.length; col++) {
			String labelCSV = csvLine[col];
			field = metadataDAO.getFileFieldFromLabelCSV(labelCSV, fileFormat);
			if (field != null) {
				CSVsourceFieldDescriptors.add(field);
			} else {
				isHeaderValid = false;

				CheckException ce = new CheckException(WRONG_FILE_FIELD_CSV_LABEL);
				ce.setFoundValue(labelCSV);
				totalImportError = addError(submissionId, sourceFormat, ce, currentLine);
			}
		}

		/* Check there is no duplicated column label in the header */
		Set<String> duplicates = findDuplicates(CSVsourceFieldDescriptors);
		if (duplicates.size() > 0) {
			isHeaderValid = false;

			String errorMessage = "La ligne d'entête du fichier contient des noms en double : ";
			for (Iterator<String> it = duplicates.iterator(); it.hasNext();) {
				errorMessage = errorMessage + it.next() + " ";
			}

			CheckException ce = new CheckException(DUPLICATED_FILE_LABEL, errorMessage);
			totalImportError = addError(submissionId, sourceFormat, ce, currentLine);
		}

		/* Check all the mandatory fields are present */
		// Get the sourceFieldDescriptors from database
		List<FileFieldData> sourceFieldDescriptors = metadataDAO.getFileFields(sourceFormat);

		// Filter on isMandatory to get mandatory data only
		for (FileFieldData sourceFieldDescriptor : sourceFieldDescriptors) {
			if (sourceFieldDescriptor.getIsMandatory() && !CSVsourceFieldDescriptors.contains(sourceFieldDescriptor)) {
				isHeaderValid = false;
				CheckException ce = new CheckException(MANDATORY_HEADER_LABEL_MISSING);
				ce.setExpectedValue(sourceFieldDescriptor.getLabelCSV());
				totalImportError = addError(submissionId, sourceFormat, ce, currentLine);
			}
		}

		if (isHeaderValid) {
			return CSVsourceFieldDescriptors;
		} else {
			// Stop the import
			throw new Exception();
		}
	}

	/**
	 *
	 * @param submissionId
	 * @param sourceFormat
	 * @param ce
	 *            the CheckException to add
	 * @param row
	 * @return totalImportError the number of errors found
	 * @throws Exception
	 */
	public Integer addError(Integer submissionId, String sourceFormat, CheckException ce, Integer currenLine) throws Exception {
		// Complete the description of the problem
		ce.setSourceFormat(sourceFormat);
		// ce.setLineNumber(row + 1);
		ce.setLineNumber(currenLine);
		ce.setSubmissionId(submissionId);

		logger.debug("setFoundValue value: " + ce.getFoundValue());

		if (totalImportError < limitImportError) {
			logger.error("CheckException", ce);
			totalImportError = totalImportError + 1;

			// We store the check exception in database and continue reading the line
			checkErrorDAO.createCheckError(ce);
		} else {
			// limitImportError is reached, we stop doing the import checks
			throw ce;
		}
		return totalImportError;
	}

	/**
	 * @param listContainingDuplicates
	 *
	 * @return Set<String> the duplicated data labels
	 */
	public Set<String> findDuplicates(List<FileFieldData> listContainingDuplicates) {
		final Set<String> duplicates = new HashSet<String>();
		final Set<FileFieldData> set1 = new HashSet<FileFieldData>();

		for (FileFieldData fileFieldData : listContainingDuplicates) {
			if (!set1.add(fileFieldData)) {
				duplicates.add(fileFieldData.getLabel());
			}
		}
		return duplicates;
	}

}
