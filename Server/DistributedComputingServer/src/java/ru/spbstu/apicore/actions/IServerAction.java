package ru.spbstu.apicore.actions;

/**
 *
 * @author igofed
 */
public interface IServerAction {

    public Object process(long id, Object request) throws ServerException;
    
}
