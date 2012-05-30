package ru.spbstu.clients;

import java.util.HashMap;
import ru.spbstu.apicore.computing.ComputingTask;
import ru.spbstu.clients.clientidgenerators.IClientIdGenerator;
import ru.spbstu.clients.clientidgenerators.SequenceIdGenerator;

/**
 *
 * @author igofed
 */
public class ClientsHolder {

    private static ClientsHolder self;

    static {
        self = new ClientsHolder();
    }

    public static ClientsHolder self() {
        return self;
    }
    private HashMap<Long, Client> clients = null;
    private IClientIdGenerator clientIdGenerator = null;

    private ClientsHolder() {
        clients = new HashMap<Long, Client>();
        clientIdGenerator = new SequenceIdGenerator();
    }

    public synchronized boolean isClientRegistered(Long id) {
        return clients.containsKey(id);
    }

    public synchronized Long registerClient(Client client) {
        Long id = clientIdGenerator.generateNewId();

        clients.put(id, client);

        return id;
    }

    public synchronized void deregisterClient(Long id) {
        clients.remove(id);
    }
    
    public synchronized void updateCurrentTask(Long clientId, ComputingTask task){
        //todo: remove hack
        if(!clients.containsKey(clientId))
            clients.put(clientId, new Client());
        
        Client client = clients.get(clientId);
        client.setCurrentTask(task);      
    }
}
