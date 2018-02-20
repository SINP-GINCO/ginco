package fr.ifn.ogam.common.util;

/**
 * Utility class used to launch an external process from java.
 * 
 * This class read the outputstream and the errorstream of the launched process to ensure that the process will never be stuck by a system buffer full. Cf
 * 
 * @author Michael C. Daconta
 * http://www.javaworld.com/javaworld/jw-12-2000/jw-1229-traps.html?page=4
 */
public class ExecLauncher {

	/**
	 * Execute a system command and wait for the result.
	 * 
	 * @param command
	 *            The command to execute
	 * @return the exit value
	 * @throws Exception
	 */
	public ProcessInfo execCommand(String command) throws Exception {

		Runtime rt = Runtime.getRuntime();
		Process proc = null;

		String[] cmd = prepareCommand(command);

		// Create a new process
		proc = rt.exec(cmd);

		// any error message?
		StreamGobbler errorGobbler = new StreamGobbler(proc.getErrorStream());

		// any output?
		StreamGobbler outputGobbler = new StreamGobbler(proc.getInputStream());

		// Start to read to output
		errorGobbler.start();
		outputGobbler.start();

		// Wait for the end of the process		
		int exitVal = proc.waitFor();

		ProcessInfo processInfo = new ProcessInfo();
		processInfo.setExitValue(exitVal);
		processInfo.setError(errorGobbler.getContent());
		processInfo.setOutput(outputGobbler.getContent());

		return processInfo;
	}

	/**
	 * Prepare a command to execute depending on the OS.
	 * 
	 * @param command
	 * @return
	 */
	private String[] prepareCommand(String command) {
		String osName = System.getProperty("os.name");
		String[] cmd = new String[3];
		if (osName.equals("Windows NT") || osName.equals("Windows XP") || osName.equals("Windows Vista")) {
			cmd[0] = "cmd.exe";
			cmd[1] = "/C";
			cmd[2] = command;
		} else if (osName.equals("Windows 95")) {
			cmd[0] = "command.com";
			cmd[1] = "/C";
			cmd[2] = command;
		} else if (osName.equals("FreeBSD") || osName.equals("Linux")) {
			cmd[0] = "/bin/sh";
			cmd[1] = "-c";
			cmd[2] = command;
		}

		return cmd;

	}

}
