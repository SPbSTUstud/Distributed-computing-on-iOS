package ru.spbstu.apicore.actions;

/**
 * Interface for all actions
 * @author igofed
 */
public interface IServerAction {

    public Object process(Long id, Object request) throws ServerException;
    
}
