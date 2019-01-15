import java.io.IOException;

public class Main {

    public static void main(String[] args) throws Exception {
        String file;
	    assembler a = new assembler();
	    if (args.length < 1) {
	        throw new Exception("input not specified");
        }
        file = args[0];
        try {
            a.readFile(file);
            a.assembleCode();
            if (args.length == 3 && args[1].equals("-i")) {
                a.readInitialFile(args[2]);
                a.initializeMemory();
            }
            a.outputFile();
        }
        catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
