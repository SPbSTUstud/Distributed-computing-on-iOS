package ru.spbstu.clients;

import java.util.HashMap;
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

    public boolean isClientRegistered(Long id) {
        return clients.containsKey(id);
    }

    public Long RegisterClient(Client client) {
        Long id = clientIdGenerator.generateNewId();

        clients.put(id, client);

        return id;
    }

    public void DeregisterClient(Long id) {
        clients.remove(id);
    }
}
