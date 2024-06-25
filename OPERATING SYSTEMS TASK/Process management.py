def findWaitingTime(processes, n, bursttime, waitingtime):
    waitingtime[0] = 0
    for i in range(1, n):
        waitingtime[i] = bursttime[i - 1] + waitingtime[i - 1] 
def findTurnAroundTime(processes, n, bursttime, waitingtime, turnaroundtime):
    for i in range(n):
        turnaroundtime[i] = bursttime[i] + waitingtime[i]

def findavgTime(processes, n, bursttime):
    waitingtime = [0] * n
    turnaroundtime = [0] * n 
    
    findWaitingTime(processes, n, bursttime, waitingtime)
    findTurnAroundTime(processes, n, bursttime, waitingtime, turnaroundtime)
    
    print("Processes Burst time Waiting time Turn around time")
    
    total_waitingtime = total_turnaroundtime = 0
    for i in range(n):
        total_waitingtime += waitingtime[i]
        total_turnaroundtime += turnaroundtime[i]
        print(f" {processes[i]}\t\t{bursttime[i]}\t {waitingtime[i]}\t\t {turnaroundtime[i]}")
    
    print(f"Average waiting time = {total_waitingtime / n:.2f}")
    print(f"Average turn around time = {total_turnaroundtime / n:.2f}")

if __name__ == "__main__":
    n = int(input("Enter the number of processes: "))
    
    processes = []
    burst_time = []
    
    for i in range(n):
        processid = int(input(f"Enter process ID for process {i+1}: "))
        bursttime = int(input(f"Enter burst time for process {i+1}: "))
        processes.append(processid)
        burst_time.append(bursttime)
    
    findavgTime(processes, n, burst_time)