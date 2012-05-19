package ru.spbstu.apicore.computing;

import java.math.BigInteger;

/**
 *
 * @author igofed
 */
public class ComputingTaskResult {
    private BigInteger up;
    private BigInteger down;

    public BigInteger getUp() {
        return up;
    }

    public void setUp(BigInteger up) {
        this.up = up;
    }

    public BigInteger getDown() {
        return down;
    }

    public void setDown(BigInteger down) {
        this.down = down;
    }
}
