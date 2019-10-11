package thotd.utils;

import static thotd.constants.CharacterConstant.*;

import java.io.Serializable;

public class CharacterUtil implements Serializable {
    public static boolean isStartVariableName(char character) {
        return Character.isLetter(character) || character == COLON || character == UNDERSCORE;
    }

    public static boolean isInsideVariableName(char character) {
        return Character.isLetterOrDigit(character) || character == COLON || character == UNDERSCORE;
    }

}
