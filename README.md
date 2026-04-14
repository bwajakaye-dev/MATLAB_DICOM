# Enhancing Image Quality of DICOM Radiographic Images

**Course:** Data Mining
**Author:** Sante
**Institution:** University of Alaska Anchorage
**Tool:** MATLAB (Image Processing Toolbox + Medical Imaging Toolbox)

---

## 1. Project Overview

This project uses MATLAB to read, analyze, and enhance the quality of DICOM (Digital Imaging and Communications in Medicine) radiographic images. The workflow treats image artifacts, noise, and motion blur as **anomalies** in the raw image data, and applies a series of filtering and enhancement techniques to clean them — directly analogous to the data cleaning and anomaly detection stages of a data mining pipeline.

The script:

1. Locates DICOM sample files bundled with MATLAB.
2. Reads both the pixel data and the metadata of a chosen DICOM file (`CT-MONO2-16-ankle.dcm`).
3. Inspects clinically and technically relevant metadata fields.
4. Applies five enhancement techniques to the image.
5. Quantifies the results using PSNR and SSIM metrics.
6. Writes the enhanced image back out as a new DICOM file, preserving the original metadata.

---

## 2. Connection to Data Mining

This assignment connects to the Data Mining course in three ways:

- **Anomaly detection.** Artifacts, noise, and blur in radiographic images are anomalies introduced by the imaging process (sensor noise, patient motion, hardware artifacts). Identifying and removing them is an anomaly-handling task.
- **Data cleaning / preprocessing.** Before any downstream analysis (classification, segmentation, ML pipelines), raw imaging data must be cleaned. The filters in this script are the imaging equivalent of removing outliers or correcting noisy records in a tabular dataset.
- **Metadata mining.** DICOM files carry structured metadata alongside the pixel data. Inspecting this metadata across files reveals data quality issues such as missing fields, inconsistent encodings, and varying acquisition parameters — all common concerns in real-world data mining.

Together these make DICOM enhancement a meaningful preparatory step for downstream data mining tasks such as ML-based diagnostic assistance.

---

## 3. Setup and Reproducibility

### Requirements

- **MATLAB R2022b or later** (Medical Imaging Toolbox requires R2022b+)
- **Image Processing Toolbox**
- **Medical Imaging Toolbox**

### Install the toolboxes

In MATLAB:

1. Go to **Home → Add-Ons → Get Add-Ons**
2. Search for *Image Processing Toolbox* and click **Install**
3. Search for *Medical Imaging Toolbox* and click **Install**

Verify installation:

```matlab
ver('images')           % Image Processing Toolbox
ver('medical_imaging')  % Medical Imaging Toolbox
```

### Sample data

The script uses `CT-MONO2-16-ankle.dcm`, which ships with the Image Processing Toolbox. No download is required — MATLAB locates it automatically from the toolbox sample directory.

### How to run

1. Clone or download this repository.
2. Open MATLAB and navigate to the project folder.
3. Run the main script:

```matlab
DICOM_Images
```

The script will display the original image, print metadata to the command window, show a 2×3 figure comparing all enhancement techniques, print PSNR/SSIM metrics, and write `enhanced_ankle.dcm` to the working directory.

---

## 4. Techniques Used

| # | Technique | Purpose | MATLAB Function |
|---|-----------|---------|-----------------|
| 1 | Median filtering | Removes salt-and-pepper noise and impulse artifacts | `medfilt2` |
| 2 | Wiener filtering | Adaptive noise removal that preserves edges | `wiener2` |
| 3 | Gaussian smoothing | General-purpose noise reduction | `imgaussfilt` |
| 4 | Lucy-Richardson deconvolution | Removes motion blur using an estimated PSF | `deconvlucy` |
| 5 | CLAHE (Contrast Limited Adaptive Histogram Equalization) | Improves local contrast for better visibility | `adapthisteq` |

Each technique addresses a different anomaly type. Median and Wiener filters target noise; deconvolution targets blur; CLAHE targets poor contrast (a perceptual, rather than noise-based, quality issue).

---

## 5. Quality Metrics

Two standard image quality metrics quantify each technique's effect relative to the original:

- **PSNR (Peak Signal-to-Noise Ratio)** — higher is closer to the original.
- **SSIM (Structural Similarity Index)** — values closer to 1.0 indicate higher structural similarity.

Note that since we use the original image as the reference (no ground-truth clean image is available), these metrics measure *how much* each filter has changed the image, not necessarily how much it has improved diagnostic quality. In a real research setting, ground-truth clean images would be used for proper evaluation. This limitation is itself a data-mining-relevant observation about evaluation methodology under unsupervised conditions.

---

## 6. Output

Running the script produces:

- A figure of the original image.
- A 2×3 figure comparing the original to all five enhancement techniques.
- Metadata printed to the command window.
- PSNR and SSIM values printed to the command window.
- A new file `enhanced_ankle.dcm` containing the median-filtered image with the original DICOM metadata preserved.

![MATLAB_fig2](https://github.com/user-attachments/assets/83868d50-74bc-4bda-b8a5-6baccbbb4a9a)
![MATLAB_fig1](https://github.com/user-attachments/assets/d15a66dd-da26-4127-a1e6-c728b5f8e1a1)



---

## 7. File Listing

| File | Purpose |
|------|---------|
| `DICOM_Images.m` | Main script — runs the full pipeline end-to-end |
| `enhanced_ankle.dcm` | Output DICOM file (generated on run) |
| `README.md` | This document |

---

## 8. Limitations and Future Work

- Only one DICOM file is processed; future work would mine metadata across many files (e.g., a TCIA collection) to find data quality patterns at scale.
- The motion blur PSF is assumed (length 15, angle 45°) rather than estimated from the image.
- No ground-truth reference image is available, so quality metrics are relative to the noisy original.
- Future extension: pull data from The Cancer Imaging Archive (TCIA) using the NBIA Data Retriever, and apply this pipeline at scale across a public collection.

---

## 9. References

- MathWorks: [DICOM Support in Image Processing Toolbox](https://www.mathworks.com/help/images/dicom-support-in-the-image-processing-toolbox.html)
- MathWorks: [Medical Imaging Toolbox](https://www.mathworks.com/products/medical-imaging.html)
- MathWorks: [Image Processing Toolbox](https://www.mathworks.com/products/image-processing.html)
- [The Cancer Imaging Archive (TCIA)](https://www.cancerimagingarchive.net/)
- [DICOM Standard Browser](https://dicom.innolitics.com/)
