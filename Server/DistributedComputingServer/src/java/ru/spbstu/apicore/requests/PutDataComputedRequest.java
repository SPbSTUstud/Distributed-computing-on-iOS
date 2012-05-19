package ru.spbstu.apicore.requests;

import com.thoughtworks.xstream.annotations.XStreamAlias;

/**
 *
 * @author igofed
 */
@XStreamAlias("PutDataComputedRequest")
public class PutDataComputedRequest {
    private String up;
    private String down;

    public String getUp() {
        return up;
    }

    public void setUp(String up) {
        this.up = up;
    }

    public String getDown() {
        return down;
    }

    public void setDown(String down) {
        this.down = down;
    }
}
