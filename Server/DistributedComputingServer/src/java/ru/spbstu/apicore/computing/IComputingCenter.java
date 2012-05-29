package ru.spbstu.apicore.computing;

import java.math.BigDecimal;

/**
 *
 * @author igofed
 */
public interface IComputingCenter {
    ComputingTask getNewTask(Long clientId);
    void loadComputedTask(Long clientId, ComputingTaskResult result);
    BigDecimal getCurrentResult();
}
