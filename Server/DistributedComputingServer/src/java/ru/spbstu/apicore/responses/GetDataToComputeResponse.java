package ru.spbstu.apicore.responses;

import com.thoughtworks.xstream.annotations.XStreamAlias;

/**
 *
 * @author igofed
 */
@XStreamAlias("GetDataToComputeResponse")
public class GetDataToComputeResponse {
    private int from;
    private int to;

    public int getFrom() {
        return from;
    }

    public void setFrom(int from) {
        this.from = from;
    }

    public int getTo() {
        return to;
    }

    public void setTo(int to) {
        this.to = to;
    }
}
