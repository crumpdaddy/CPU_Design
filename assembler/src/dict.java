import java.util.HashMap;

public class dict {
    public HashMap<String, String>  dictMap;
    public dict() {
        dictMap = new HashMap<>();
        dictMap.put("HALT", "0000");
        dictMap.put("AND", "1");
        dictMap.put("OR", "2");
        dictMap.put("XOR", "3");
        dictMap.put("ADD", "4");
        dictMap.put("SUB", "5");
        dictMap.put("ADDI", "6");
        dictMap.put("MUL", "7");
        dictMap.put("LSL", "8C");
        dictMap.put("LSA", "88");
        dictMap.put("RSL", "84");
        dictMap.put("RSA", "80");
        dictMap.put("COMP", "90");
        dictMap.put("TEST", "98");
        dictMap.put("COPY", "A0");
        dictMap.put("COPC", "B");
        dictMap.put("LOAD", "C4");
        dictMap.put("STOR", "C0");
        dictMap.put("PUSH", "C80");
        dictMap.put("POP", "CC0");
        dictMap.put("JMPL", "D");
        dictMap.put("JMPE", "E");
        dictMap.put("JUMP", "F");
        dictMap.put("$R0", "0");
        dictMap.put("$R1", "1");
        dictMap.put("$R2", "2");
        dictMap.put("$R3", "3");
        dictMap.put("$R4", "4");
        dictMap.put("$R5", "5");
        dictMap.put("$R6", "6");
        dictMap.put("$R7", "7");
        dictMap.put("$R8", "8");
        dictMap.put("$R9", "9");
        dictMap.put("$R10", "A");
        dictMap.put("$R11", "B");
        dictMap.put("$R12", "C");
        dictMap.put("$R13", "D");
        dictMap.put("$R14", "E");
        dictMap.put("$R15", "F");
        dictMap.put("0", "0");
        dictMap.put("1", "1");
        dictMap.put("2", "2");
        dictMap.put("3", "3");
        dictMap.put("4", "4");
        dictMap.put("5", "5");
        dictMap.put("6", "6");
        dictMap.put("7", "7");
        dictMap.put("8", "8");
        dictMap.put("9", "9");
        dictMap.put("A", "A");
        dictMap.put("B", "B");
        dictMap.put("C", "C");
        dictMap.put("D", "D");
        dictMap.put("E", "E");
        dictMap.put("F", "F");
        dictMap.put("10", "A");
        dictMap.put("12", "B");
        dictMap.put("13", "C");
        dictMap.put("14", "D");
        dictMap.put("15", "E");
        dictMap.put("16", "F");
        dictMap.put("#", " //");
    }

    public String get(String key) {
        if (dictMap.containsKey(key)) {
            return dictMap.get(key);
        }
        else {
            throw new NullPointerException("Key does not exist: " + key);
        }
    }
    public boolean contains(String key) {
        return dictMap.containsKey(key);
    }
}
