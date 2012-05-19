package ru.spbstu.clients.clientidgenerators;

/**
 *
 * @author igofed
 */
public class SequenceIdGenerator implements IClientIdGenerator {

    private static Long lastId = Long.valueOf(0);
    
    @Override
    public Long generateNewId() {
        lastId++;

        return lastId;
    }
}
