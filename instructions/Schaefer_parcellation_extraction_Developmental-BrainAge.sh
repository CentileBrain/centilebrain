################################################################################
export FREESURFER_HOME=/arc/project/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

################################################################################
export SUBJECTS_DIR=/scratch/data/FreeSurfer_results

##Schaefer1000 atlas
for sub in `ls $SUBJECTS_DIR`
do  
  mri_surf2surf --hemi lh \
    --srcsubject fsaverage \
    --trgsubject $sub \
    --sval-annot $FREESURFER_HOME/subjects/fsaverage/label/lh.Schaefer2018_1000Parcels_7Networks_order.annot \
    --tval $SUBJECTS_DIR/$sub/label/lh.Schaefer2018_1000Parcels_7Networks_order.annot

  mri_surf2surf --hemi rh \
    --srcsubject fsaverage \
    --trgsubject $sub \
    --sval-annot $FREESURFER_HOME/subjects/fsaverage/label/rh.Schaefer2018_1000Parcels_7Networks_order.annot \
    --tval $SUBJECTS_DIR/$sub/label/rh.Schaefer2018_1000Parcels_7Networks_order.annot

  cd $SUBJECTS_DIR/$sub/
  mris_anatomical_stats -a $SUBJECTS_DIR/$sub/label/lh.Schaefer2018_1000Parcels_7Networks_order.annot -b -f $SUBJECTS_DIR/$sub/stats/lh.Schaefer1000.stats $sub lh
  mris_anatomical_stats -a $SUBJECTS_DIR/$sub/label/rh.Schaefer2018_1000Parcels_7Networks_order.annot -b -f $SUBJECTS_DIR/$sub/stats/rh.Schaefer1000.stats $sub rh
done

cd $SUBJECTS_DIR
aparcstats2table --hemi lh --subjects subj* --parc Schaefer1000 --meas area --tablefile lh.Schaefer1000.area.txt
aparcstats2table --hemi rh --subjects subj* --parc Schaefer1000 --meas area --tablefile rh.Schaefer1000.area.txt
aparcstats2table --hemi lh --subjects subj* --parc Schaefer1000 --meas thickness --tablefile lh.Schaefer1000.thickness.txt
aparcstats2table --hemi rh --subjects subj* --parc Schaefer1000 --meas thickness --tablefile rh.Schaefer1000.thickness.txt
