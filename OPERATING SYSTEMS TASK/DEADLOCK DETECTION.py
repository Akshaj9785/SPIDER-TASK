def get_input():
    num_processes = int(input("Enter the number of processes: "))
    num_resources = int(input("Enter the number of resources: "))
    
    max_matrix = []
    print("Enter the maximum matrix:")
    for i in range(num_processes):
        max_matrix.append(list(map(int, input().split())))
    
    allocation_matrix = []
    print("Enter the allocation matrix:")
    for i in range(num_processes):
        allocation_matrix.append(list(map(int, input().split())))
    
    available = list(map(int, input("Enter the available resources: ").split()))
    
    return num_processes, num_resources, max_matrix, allocation_matrix, available

def calculate_need(num_processes, num_resources, max_matrix, allocation_matrix):
    need_matrix = []
    for i in range(num_processes):
        row = []
        for j in range(num_resources):
            row.append(max_matrix[i][j] - allocation_matrix[i][j])
        need_matrix.append(row)
    return need_matrix

def is_safe(num_processes, num_resources, allocation_matrix, need_matrix, available):
    finish = [False] * num_processes
    work = available[:]
    
    while True:
        found = False
        for i in range(num_processes):
            if not finish[i]:
                if all(need_matrix[i][j] <= work[j] for j in range(num_resources)):
                    for k in range(num_resources):
                        work[k] += allocation_matrix[i][k]
                    finish[i] = True
                    found = True
        
        if not found:
            return all(finish)

def main():
    num_processes, num_resources, max_matrix, allocation_matrix, available = get_input()
    need_matrix = calculate_need(num_processes, num_resources, max_matrix, allocation_matrix)
    
    if is_safe(num_processes, num_resources, allocation_matrix, need_matrix, available):
        print("No Deadlock detected.")
    else:
        print("Deadlock detected!")

if __name__ == "__main__":
    main()
