import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

public class assembler {
    private dict assemblerDict;
    private HashMap<String, Integer> labels;
    private ArrayList<String> assembledCode;
    private ArrayList<String>  assemblyCode;
    private HashMap<Integer ,String> initialMemory;
    private int offset;

    public assembler()  {
        assemblerDict = new dict();
        labels = new HashMap<>();
        assembledCode = new ArrayList<>();
        assemblyCode = new ArrayList<>();
        initialMemory = new HashMap<>();
        offset = 0;
    }

    public void readFile(String fileName) throws IOException {
        File file = new File("./programs/" + fileName);
        BufferedReader br = new BufferedReader(new FileReader(file));
        String str;
        int i = 0;
        while ((str = br.readLine()) != null) {
            str = str.toUpperCase();
            if (str.charAt(0) == ':') {
                String subStr = str.substring(1, str.indexOf(' '));
                labels.put(subStr, i);
            }
            assemblyCode.add(str);
            if (str.charAt(0) != '#') i++;
        }
    }

    public void readInitialFile(String fileName) throws Exception {
        File file = new File("./programs/" + fileName);
        BufferedReader br = new BufferedReader(new FileReader(file));
        String str;
        int i = 1;
        while ((str = br.readLine()) != null) {
            String[] split = str.split("\\s+");
            if (split.length < 2) throw new Exception("Error reading memory initialization file. Line: " + i);
            if (split[0].charAt(0) != '#' && split[1].charAt(0) != '#') {
                if (!isInt(split[0])) throw new Exception("Error reading memory initialization file. Line: " + i);
                initialMemory.put(Integer.parseInt(split[0]), split[1].toUpperCase());
            }
        }
    }

    public void initializeMemory() throws Exception {
        for (Integer key : initialMemory.keySet()) {
            setMemory(key, initialMemory.get(key));
        }
    }

    public void assembleCode() throws Exception {
        for (int i = 0; i < assemblyCode.size(); i++) {
            String str = assemblyCode.get(i);
            String assembled = "";
            String[] split = str.split("\\s+");
            for (int j = 0; j < split.length; j++) {
                if (split[j].charAt(0) == '#') {
                    if (j == 0) throw new Exception("Comments can only go on same line as command");
                    if (str.indexOf('#') < str.length() - 1) {
                        assembled += " //" + str.substring(str.indexOf('#') + 1);
                    }
                    break;
                }
                else if (split[j].charAt(0) != ':') {
                    if (assembled.equals("D") || assembled.equals("E") || assembled.equals("F")) {
                        if (isReg(split[j])) {
                            assembled += "00" + assemblerDict.get(split[j]);
                        }
                        else if (isInt(split[j])) {
                            int x = (2048 | toInt(split[j]));
                            assembled += toHex(Integer.toString(x), 3);
                        }
                        else if (split[j].charAt(0) == '*') {
                            int x = (2048 | labels.get(split[j].substring(1)));
                            assembled += toHex(Integer.toString(x), 3);
                        }
                        else {
                            throw new Exception("Invalid jump instruction. Line: " + i);
                        }
                    }
                    else if (split[j].charAt(0) == '*') {
                        assembled += toHex(Integer.toString(labels.get(split[j].substring(1))), 2);
                    }
                    else if (isInt(split[j])) {
                        assembled += toHex(split[j], 2);
                    }
                    else {
                        assembled += assemblerDict.get(split[j]);
                    }
                }
            }
            assembledCode.add(assembled);
        }
        for (int j = assemblyCode.size(); j < 1024; j++) {
            assembledCode.add("0000");
        }
    }

    public void outputFile() throws IOException {
        Path file = Paths.get("output.txt");
        Files.write(file, assembledCode, Charset.forName("UTF-8"));
    }

    public void setMemory(int address, String val) throws Exception {
        if (address < 0 || address > 1023) {
            throw new Exception("Invalid address. Out of range");
        }
        if (val == null || val.length() <= 1) {
            throw new Exception("Invalid data");
        }
        String data;
        if (val.charAt(0) == 'H') {
            data = val.substring(1);
            if (data.length() < 4) {
                System.out.println("Data too small. Padding leading digits with 0");
                while (data.length() < 4) {
                    data = "0" + data;
                }
            }
            data = data.toUpperCase();
            for (int i = 0; i < 4; i++) {
                if (!Character.isDigit(data.charAt(i)) || data.charAt(i) != 'A'
                        || data.charAt(i) != 'B' || data.charAt(i) != 'C'
                        || data.charAt(i) != 'D' || data.charAt(i) != 'E'
                        || data.charAt(i) != 'F') {
                    throw new Exception("Invalid data. Not valid Hex");
                }
            }
        }
        else if (val.charAt(0) == 'D') {
            data = val.substring(1);
            if (!isInt(data)) {
                throw new Exception("Invalid data. Not an Integer");
            }
            data = toHex(data, 4);
        }
        else if (val.charAt(0) == 'B') {
            data = val.substring(1);
            for (int i = 0; i < data.length(); i++) {
                if (data.charAt(i) != '0' || data.charAt(i) != '1') {
                    throw new Exception("Invalid data. Not valid binary");
                }
            }
            int decimal = Integer.parseInt(data, 2);
            data = toHex(Integer.toString(decimal), 4);
        }
        else {
            throw new Exception("Invalid data: " + val);
        }
        if (data.length() > 4) {
            System.out.println("Data too large, only using lower bits");
            data = data.substring(data.length() - 5);
        }
        assembledCode.set(address, data);
    }

    private boolean isInt(String str) {
        if (str == null || str.length() <= 0) return false;
        for (int i = 0; i < str.length(); i++) {
            if (!Character.isDigit(str.charAt(i)) && str.charAt(i) != '-') return false;
        }
        return true;
    }

    private boolean isReg(String str) {
        if (str == null || str.length() < 3) return false;
        if (str.charAt(0) != '$') return false;
        return assemblerDict.contains(str);
    }

    private String toHex(String str, int len) {
        int x = Integer.parseInt(str);
        boolean negative = x < 0;
        String hex = Integer.toHexString(x);
        while (hex.length() < len) {
            if (negative) {
                hex = "F" + hex;
            }
            else {
                hex = "0" + hex;
            }
        }
        if (hex.length() > len) {
            hex = hex.substring(hex.length() - len);
        }
        hex = hex.toUpperCase();
        return hex;
    }

    private int toInt(String str) {
        return Integer.parseInt(str);
    }
}

