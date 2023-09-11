################## please change the folder names to your own ##################
export FREESURFER_HOME=/arc/home/ryg/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=/scratch/ryg/01_FS

################################################################################
### first visit and download annotation files at https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal/Parcellations/FreeSurfer5.3/fsaverage/label ###
### copy the downloaded annotations files to your FreeSurfer folder ($FREESURFER_HOME/subjects/fsaverage/label) #############################################################################################
for sub in `ls $SUBJECTS_DIR`
do  

  mri_surf2surf --hemi lh \
  --srcsubject fsaverage \
  --trgsubject $sub \
  --sval-annot $FREESURFER_HOME/subjects/fsaverage/label/lh.Schaefer2018_400Parcels_7Networks_order.annot \
  --tval $SUBJECTS_DIR/$sub/label/lh.Schaefer2018_400Parcels_7Networks_order.annot

  mri_surf2surf --hemi rh \
  --srcsubject fsaverage \
  --trgsubject $sub \
  --sval-annot $FREESURFER_HOME/subjects/fsaverage/label/rh.Schaefer2018_400Parcels_7Networks_order.annot \
  --tval $SUBJECTS_DIR/$sub/label/rh.Schaefer2018_400Parcels_7Networks_order.annot

  cd $SUBJECTS_DIR/$sub/
  mris_anatomical_stats -a $SUBJECTS_DIR/$sub/label/lh.Schaefer2018_400Parcels_7Networks_order.annot -b -f $SUBJECTS_DIR/$sub/stats/lh.Schaefer400.stats $sub lh
  mris_anatomical_stats -a $SUBJECTS_DIR/$sub/label/rh.Schaefer2018_400Parcels_7Networks_order.annot -b -f $SUBJECTS_DIR/$sub/stats/rh.Schaefer400.stats $sub rh

done


################################################################################
aparcstats2table --hemi lh --subjects *sub0* --parc Schaefer400 --meas area --tablefile lh.Schaefer400_area.txt
aparcstats2table --hemi rh --subjects *sub0* --parc Schaefer400 --meas area --tablefile rh.Schaefer400_area.txt
aparcstats2table --hemi lh --subjects *sub0* --parc Schaefer400 --meas thickness --tablefile lh.Schaefer400_thickness.txt
aparcstats2table --hemi rh --subjects *sub0* --parc Schaefer400 --meas thickness --tablefile rh.Schaefer400_thickness.txt
