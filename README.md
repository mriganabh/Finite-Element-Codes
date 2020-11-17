This folder contains a 2D Linear elastic Finite Element Code solved in Matlab. The description 
of all the individual files are as follows:

1. Main.m 
	- It is the Main File
	- It progresses the state of the system every time step
	- It calls various other subroutines like TwoDFEgetinput, plot_model, fecalc, etc.

2. TwoDFEgetinput.m
	- This subroutine allows the user to choose the input file
	- It also reads the entire input file which includes
		  i. Material Data
		 ii. Mesh Parameters
		iii. Nodal Coordinates
		 iv. Element Data
		  v. Displacement and Loading BCs

3. plot_model.m
	- This subroutine plots the input model along with the node numbers and element numbers

4. fecalc.m
	- This subroutine evaluates the global Mass & Stiffness matrices and global force vector at the specified instant of time "time_cur"

5. first_step_computation.m
	- This subroutine computes the initial acceleration of the system

6. compute_stress.m
	- This subroutine computes the stresses at the integration points, elemental stresses & unaveraged nodal stresses using current displacement and removes elements with principal stress > limit specified in input file  

7. patch_face_update.m
	- This subroutine determines the connectivity of the active elements at the specified instant of time (or elements which are not deleted) 

8. plot_elemstrs.m
	- This subroutine plots the elemental stresses

9. plot_avg_nodalstrs.m
	- This subroutine plots the averaged nodal stresses
