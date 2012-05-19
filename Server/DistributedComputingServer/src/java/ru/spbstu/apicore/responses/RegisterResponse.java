package ru.spbstu.apicore.responses;

import com.thoughtworks.xstream.annotations.XStreamAlias;

/**
 *
 * @author igofed
 */

@XStreamAlias("RegisterResponse")
public class RegisterResponse {
    private long id;

    public long getId() {
        return id;
    }

    public void setId(long Id) {
        this.id = Id;
    }
}
