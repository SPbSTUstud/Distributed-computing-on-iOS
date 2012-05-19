package ru.spbstu.apicore.actions;

import ru.spbstu.apicore.requests.Register;
import ru.spbstu.apicore.responses.RegisterResponse;
import ru.spbstu.clients.Client;
import ru.spbstu.clients.ClientsHolder;

/**
 *
 * @author igofed
 */
public class RegisterAction implements IServerAction {

    @Override
    public Object process(Long id, Object request) throws ServerException {
        
        Register register = (Register)request;
        
        Client client = new Client();
        
        Long newId = ClientsHolder.self().RegisterClient(client);
        
        RegisterResponse response = new RegisterResponse();
        response.setId(newId);
        
        return response;
    }
    
}
