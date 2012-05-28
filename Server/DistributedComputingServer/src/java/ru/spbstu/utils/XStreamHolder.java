package ru.spbstu.utils;

import com.thoughtworks.xstream.XStream;
import ru.spbstu.apicore.requests.RegisterRequest;
import ru.spbstu.apicore.responses.RegisterResponse;

/**
 *
 * @author igofed
 */
public class XStreamHolder {

    private static XStream xStream = null;

    static {
        xStream = new XStream();
        xStream.processAnnotations(RegisterRequest.class);
        xStream.processAnnotations(RegisterResponse.class);
    }
    
    public static XStream getXStream(){
        return xStream;
    }
}