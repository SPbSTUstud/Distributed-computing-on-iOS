package ru.spbstu.apicore.computing;

/**
 *
 * @author igofed
 */
public class ComputingCenterHolder {

    private static IComputingCenter computingCenter;
    
    static{
        computingCenter = null;
    }
    
    public static IComputingCenter getComputingCenter(){
        return computingCenter;
    }
}
