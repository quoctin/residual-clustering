## Accurate and Scalable Image Clustering Based on Sparse Representation of Camera Fingerprint

### IEEE Transactions on Information Forensics and Security, 2019. [[arXiv]](https://arxiv.org/abs/1810.07945) [[publisher]](https://ieeexplore.ieee.org/document/8576558)

### [Quoc-Tin Phan](https://quoctin.github.io), Giulia Boato, Francesco G. B. De Natale

MMLab, DISI
University of Trento, Italy


### Abstract
In this paper, we propose a method to cluster images with respect to their acquisition camera based on noise residuals. Given a set of noise residuals, our method first finds their sparse representation and perform clustering afterwards. Our method is accurate and scalable, owning potential for real-world applications.

### 1) Prerequisites
First clone this repo:

```git clone --single-branch https://github.com/quoctin/residual-clustering.git```

Navigate to **/mex** and execute the following command in Matlab:

```>>compile```

### 2) Download test data

Download our small test data from [here](https://drive.google.com/file/d/1kEf8Yg-thCk5vVlES4EevCX5_fWEmAQg/view?usp=sharing) (~500 MBs) into **/data**.

Download our large test data from [here](https://drive.google.com/file/d/11YM907UZZS7vef8qbX88-XTyMXtQ3Pew/view?usp=sharing) (~6.5 GBs), decompress and copy **\*.mat** to **/data**.

### 3) Run demo
Execute the following command in Matlab for medium-scale clustering:

```>>run_demo```

For large-scale clustering, execute:

```>>run_ls_demo```

To prepare your own data for large-scale clustering, please follow the convention defined in **%% setup data** of ```run_ls_demo```.

### 4) Citation
If you use our code, please cite to:

```
@ARTICLE{Phan2019,
	author={Q.-T. Phan and G. Boato and F. G. B. De Natale},
	journal={IEEE Trans. on Information Forensics and Security},
	title={{Accurate and Scalable Image Clustering Based On Sparse Representation of Camera Fingerprint}},
	year={2019}
}
```

### 5) Questions
For further questions, please contact [Quoc-Tin Phan](https://quoctin.github.io).
