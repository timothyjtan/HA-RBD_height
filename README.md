# Rosetta modeling of HA RBD mutations

## Dependencies

* [Rosetta Software Suite](https://www.rosettacommons.org/software/license-and-download)
    * Either an academic or commercial license is required. One can request a license in the link above.
* [PyMOL](https://pymol.org/2/)
* [pdb-tools](http://www.bonvinlab.org/pdb-tools/)

## Input Files

* Resfiles in the **point_mutagenesis** folder for mutating the specified residues
* **Mich14_RBD.pdb** containing the structure of monomeric HA RBD for mutagenesis. The original PDB is [6BKT](https://www.rcsb.org/structure/6BKT); a monomer was extracted for Rosetta modeling.

## Steps

1. Renumber the PDB using `pdb_reres Mich14_RBD.pdb > Mich14_RBD_renum.pdb` in pdb-tools. Use the renumbered file for subsequent steps.

2. For each mutation, perform point mutagenesis in triplicate. Point mutagenesis was run using `<rosetta_location>/main/source/bin/fixbb.static.macosclangrelease -s Mich14_RBD_renum.pdb -resfile <Mutation>.resfile -nstruct 100` while in the folder where `Mich14_RBD_renum.pdb` is located. One-hundred poses were generated.
    * Change `macosclangrelease` depending on your operating system.
    * Each replicate for each mutation took approximately 30 minutes to run on a computer with 16 GB RAM and a 2 GHz Quad-Core Intel Core i5 processor.

3. Examine the .sc score file and select the pose that has the lowest overall score. Copy this file to another folder for fast relax.

4. Generate a constraint file using `<rosetta_location>/main/source/bin/minimize_with_cst.static.linuxgccrelease -s <pdb file with lowest score after point mutagenesis>.pdb -in:file:fullatom -ignore_unrecognized_res -fa_max_dis 9.0 -database <rosetta_location>/main/database/ -ddg::harmonic_ca_tether 0.5 -score:weights <rosetta_location>/main/database/scoring/weights/pre_talaris_2013_standard.wts -restore_pre_talaris_2013_behavior -ddg::constraint_weight 1.0 -ddg::out_pdb_prefix min_cst_0.5 -ddg::sc_min_only false -score:patch <rosetta_location>/main/database/scoring/weights/score12.wts_patch > mincst.log`.

5. Convert the .log file to a .cst file using `bash <rosetta_location>/main/source/src/apps/public/ddg/convert_to_cst_file.sh ./mincst.log > ./Constraint.cst`.

6. With the **Constraint.cst** file and the pdb file of the lowest scoring pose from point mutagenesis in the same folder, perform fast relax using `<rosetta_location>/main/source/bin/relax.static.linuxgccrelease -database <rosetta_location>/main/database/ -in:file:s <pdb file with lowest score after point mutagenesis>.pdb -in:file:fullatom -relax:fast -constraints:cst_file Constraint.cst -relax:ramp_constraints false -nstruct 30`. Thirty poses were generated. Wild-type HA RBD fast relax was performed without prior point mutagenesis.
    * Change `macosclangrelease` depending on your operating system.
    * Each replicate for each mutation took approximately 2 hours to run on a computer with 16 GB RAM and a 2 GHz Quad-Core Intel Core i5 processor.

7. Using PyMOL, measure the distance between the side chain oxygen atom of Y98 (original numbering; Y42 in renumbered PDB) and the alpha carbon of residue 190 (original numbering; residue 134 in renumbered PDB). Set the number of decimal places to 4 using `set label_distance_digits, 4`.

## Notes

* The parameter _nstruct_ can be varied depending on the number of output poses. In our case, we chose 100 output poses for fixed backbone point mutagenesis and 30 output poses for fast relax. The lowest scoring poses after fast relax are in the **fast_relax** folder.
* Scores for fixed backbone point mutagenesis and fast relax are in the **score** folder.
