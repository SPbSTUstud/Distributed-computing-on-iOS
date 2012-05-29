package ru.spbstu.utils;

import com.thoughtworks.xstream.XStream;
import ru.spbstu.apicore.requests.GetDataToComputeRequest;
import ru.spbstu.apicore.requests.PutDataComputedRequest;
import ru.spbstu.apicore.requests.RegisterRequest;
import ru.spbstu.apicore.responses.GetDataToComputeResponse;
import ru.spbstu.apicore.responses.PutDataComputedResponse;
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
        xStream.processAnnotations(GetDataToComputeRequest.class);
        xStream.processAnnotations(GetDataToComputeResponse.class);
        xStream.processAnnotations(PutDataComputedRequest.class);
        xStream.processAnnotations(PutDataComputedResponse.class);
    }
    
    public static XStream getXStream(){
        return xStream;
    }
}
