LASTIT=$(cat d4est_solver_krylov_petsc_iteration_info.log | tail -n1 | cut -d ' ' -f9)
for i in $(seq 0 $LASTIT); do
    DOF=$(cat d4est_solver_krylov_petsc_iteration_info.log | grep " $i 0 " | head -n1 | tail -n1 | cut -d ' ' -f8)
    NUM=$(cat -n d4est_solver_krylov_petsc_iteration_info.log | grep " $i 0 " | head -n2 | tail -n1 | cut -d 'E' -f1)
    NUMM1=$(echo "$NUM - 1" | bc -l)
    ITS=$(sed -n "${NUMM1}p" d4est_solver_krylov_petsc_iteration_info.log | cut -d ' ' -f10)

 #   echo $NUMM1
 #   ITS="$(sed -n '${NUMM1}p' d4est_solver_krylov_petsc_iteration_info.log | cut -d ' ' -f9)"
    #DOF=$(cat d4est_solver_krylov_petsc_iteration_info.log | tail -n1 | cut -d ' ' -f8)
    echo $i $DOF $NUMM1 $ITS
done
#cat -n d4est_solver_krylov_petsc_iteration_info.log | grep " 12 0 " | head -n2 | tail -n1 | cut -d 'E' -f1
#sed -n '131p' d4est_solver_krylov_petsc_iteration_info.log
