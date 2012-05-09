package ru.spbstu.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 *
 * @author igofed
 */
public class StringUtils {

    public static String stringFromInputStream(InputStream stream) throws IOException {

        StringBuilder builder = new StringBuilder();

        try {
            String line = "";
            BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
            while ((line = reader.readLine()) != null) {
                builder.append(line);
            }
        } finally {
            stream.close();
        }
        
        return builder.toString();
    }
}
