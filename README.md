# 水下图像增强
## 代码说明
blue_green: 白平衡处理代码，蓝色和红色通道补偿<br>
only_green: 白平衡处理代码，仅仅对红色通道进行绿色通道补偿<br>
auto_white: 根据绿色与蓝色通道的比值来定义一个阈值来自动选择是否进行蓝色通道<br>
imsharp: 图像锐化<br>
Laplacian_weight: 拉普拉斯对比度权重<br>
saliency_detection:显著性权重，论文《Frequency-tuned Salient Region Detection》的代码<br>
Saturation_weight: 饱和权重<br>
lalapPyamid: 拉普拉斯金字塔<br>
guassianPyamid: 高斯金字塔<br>
underwater_enchance: 合并的代码，伽马变换、权重归一化、金字塔融合<br>
runcode:  运行使用了多尺度融合的水下图像增强的代码，输入为9张图片，直接点击运行<br>
