<?php
namespace Ign\Bundle\GincoBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * Layer
 *
 * @ORM\Table(name="mapping.layer")
 * @ORM\Entity
 */
class Layer implements \JsonSerializable {

	/**
	 * The logical name of the layer.
	 * 
	 * @var string @ORM\Id
	 *      @ORM\Column(name="name", type="string", length=50, unique=true, options={"comment"="Logical name of the layer"})
	 */
	private $name;

	/**
	 * The label of the layer.
	 * 
	 * @var string @ORM\Column(name="label", type="string", length=100, nullable=true, options={"comment"="Label of the layer"})
	 */
	private $label;

	/**
	 * The name of the service layer composing this logical layer.
	 * 
	 * @var string @ORM\Column(name="service_layer_name", type="string", length=500)
	 */
	private $serviceLayerName;

	/**
	 * Indicate if the layer is transparent.
	 * 
	 * @var bool @ORM\Column(name="is_transparent", type="boolean", nullable=true)
	 */
	private $isTransparent;

	/**
	 * Default value of layer opacity : 0 to 100, default value = 100.
	 * 
	 * @var int @ORM\Column(name="default_opacity", type="integer", nullable=true)
	 */
	private $defaultOpacity;

	/**
	 * Indicate if the layer is a base layer.
	 * 
	 * @var bool @ORM\Column(name="is_base_layer", type="boolean", nullable=true)
	 */
	private $isBaseLayer;

	/**
	 * Force OpenLayer to request one image each time.
	 * 
	 * @var bool @ORM\Column(name="is_untiled", type="boolean", nullable=true)
	 */
	private $isUntiled;

	/**
	 * The max scale of apparition of the layer.
	 * 
	 * @var int @ORM\ManyToOne(targetEntity="ZoomLevel")
	 *      @ORM\JoinColumn(name="max_zoom_level", referencedColumnName="zoom_level")
	 */
	private $maxZoomLevel;

	/**
	 * The min scale of apparition of the layer.
	 * 
	 * @var int @ORM\ManyToOne(targetEntity="ZoomLevel")
	 *      @ORM\JoinColumn(name="min_zoom_level", referencedColumnName="zoom_level")
	 */
	private $minZoomLevel;

	/**
	 * Indicate if the layer has a Legend available.
	 * 
	 * @var bool @ORM\Column(name="has_legend", type="boolean", nullable=true)
	 */
	private $hasLegend;

	/**
	 * If empty, the layer can be seen by any country, if not it is limited to one country.
	 * 
	 * @var string @ORM\Column(name="provider_id", type="string", length=36, nullable=true)
	 */
	private $providerId;

	/**
	 * If the layer is activated by an event, defines the category of event that will activate this layer.
	 * Possible values are : NONE, REQUEST, AGGREGATION, HARMONIZATION.
	 *
	 * @var string @ORM\Column(name="activate_type", type="string", length=36, nullable=true)
	 */
	private $activateType;

	/**
	 * Indicates the service for displaying the layers in the map panel.
	 *
	 * @var viewService @ORM\ManyToOne(targetEntity="LayerService")
	 *      @ORM\JoinColumn(name="view_service_name", referencedColumnName="name")
	 */
	private $viewService;

	/**
	 * Indicates the service to call for displaying legend.
	 *
	 * @var legendService @ORM\ManyToOne(targetEntity="LayerService")
	 *      @ORM\JoinColumn(name="legend_service_name", referencedColumnName="name")
	 */
	private $legendService;

	/**
	 * Indicates the service to call for detail panel.
	 *
	 * @var detailService @ORM\ManyToOne(targetEntity="LayerService")
	 *      @ORM\JoinColumn(name="detail_service_name", referencedColumnName="name")
	 */
	private $detailService;

	/**
	 * Indicates the service to call for wfs menu.
	 *
	 * @var featureService @ORM\ManyToOne(targetEntity="LayerService")
	 *      @ORM\JoinColumn(name="feature_service_name", referencedColumnName="name")
	 */
	private $featureService;

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		return $this->name;
	}

	/**
	 * Set name
	 *
	 * @param string $name        	
	 *
	 * @return Layer
	 */
	public function setLayerName($name) {
		$this->name = $name;
		
		return $this;
	}

	/**
	 * Get name
	 *
	 * @return string
	 */
	public function getName() {
		return $this->name;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return Layer
	 */
	public function setLayerLabel($label) {
		$this->label = $label;
		
		return $this;
	}

	/**
	 * Get label
	 *
	 * @return string
	 */
	public function getLabel() {
		return $this->label;
	}

	/**
	 * Set serviceLayerName
	 *
	 * @param string $serviceLayerName        	
	 *
	 * @return Layer
	 */
	public function setServiceLayerName($serviceLayerName) {
		$this->serviceLayerName = $serviceLayerName;
		
		return $this;
	}

	/**
	 * Get serviceLayerName
	 *
	 * @return string
	 */
	public function getServiceLayerName() {
		return $this->serviceLayerName;
	}

	/**
	 * Set isTransparent
	 *
	 * @param boolean $isTransparent        	
	 *
	 * @return Layer
	 */
	public function setIsTransparent($isTransparent) {
		$this->isTransparent = $isTransparent;
		
		return $this;
	}

	/**
	 * Get isTransparent
	 *
	 * @return bool
	 */
	public function getIsTransparent() {
		return $this->isTransparent;
	}

	/**
	 * Set defaultOpacity
	 *
	 * @param integer $defaultOpacity        	
	 *
	 * @return Layer
	 */
	public function setDefaultOpacity($defaultOpacity) {
		$this->defaultOpacity = $defaultOpacity;
		
		return $this;
	}

	/**
	 * Get defaultOpacity
	 *
	 * @return int
	 */
	public function getDefaultOpacity() {
		return $this->defaultOpacity;
	}

	/**
	 * Set isBaseLayer
	 *
	 * @param boolean $isBaseLayer        	
	 *
	 * @return Layer
	 */
	public function setIsBaseLayer($isBaseLayer) {
		$this->isBaseLayer = $isBaseLayer;
		
		return $this;
	}

	/**
	 * Get isBaseLayer
	 *
	 * @return bool
	 */
	public function getIsBaseLayer() {
		return $this->isBaseLayer;
	}

	/**
	 * Set isUntiled
	 *
	 * @param boolean $isUntiled        	
	 *
	 * @return Layer
	 */
	public function setIsUntiled($isUntiled) {
		$this->isUntiled = $isUntiled;
		
		return $this;
	}

	/**
	 * Get isUntiled
	 *
	 * @return bool
	 */
	public function getIsUntiled() {
		return $this->isUntiled;
	}

	/**
	 * Set maxZoomLevel
	 *
	 * @param integer $maxZoomLevel        	
	 *
	 * @return Layer
	 */
	public function setMaxScale($maxZoomLevel) {
		$this->maxZoomLevel = $maxZoomLevel;
		
		return $this;
	}

	/**
	 * Get maxZoomLevel
	 *
	 * @return int
	 */
	public function getMaxZoomLevel() {
		return $this->maxZoomLevel;
	}

	/**
	 * Set minZoomLevel
	 *
	 * @param integer $minZoomLevel        	
	 *
	 * @return Layer
	 */
	public function setMinScale($minZoomLevel) {
		$this->minZoomLevel = $minZoomLevel;
		
		return $this;
	}

	/**
	 * Get minZoomLevel
	 *
	 * @return int
	 */
	public function getMinZoomLevel() {
		return $this->minZoomLevel;
	}

	/**
	 * Set hasLegend
	 *
	 * @param boolean $hasLegend        	
	 *
	 * @return Layer
	 */
	public function setHasLegend($hasLegend) {
		$this->hasLegend = $hasLegend;
		
		return $this;
	}

	/**
	 * Get hasLegend
	 *
	 * @return bool
	 */
	public function getHasLegend() {
		return $this->hasLegend;
	}

	/**
	 * Set providerId
	 *
	 * @param string $providerId        	
	 *
	 * @return Layer
	 */
	public function setProviderId($providerId) {
		$this->providerId = $providerId;
		
		return $this;
	}

	/**
	 * Get providerId
	 *
	 * @return string
	 */
	public function getProviderId() {
		return $this->providerId;
	}

	/**
	 * Set activateType
	 *
	 * @param string $activateType        	
	 *
	 * @return Layer
	 */
	public function setActivateType($activateType) {
		$this->activateType = $activateType;
		
		return $this;
	}

	/**
	 * Get activateType
	 *
	 * @return string
	 */
	public function getActivateType() {
		return $this->activateType;
	}

	/**
	 * Set viewService
	 *
	 * @param string $viewService        	
	 *
	 * @return Layer
	 */
	public function setViewService($viewService) {
		$this->viewService = $viewService;
		
		return $this;
	}

	/**
	 * Get viewService
	 *
	 * @return string
	 */
	public function getViewService() {
		return $this->viewService;
	}

	/**
	 * Set legendService
	 *
	 * @param string $legendService        	
	 *
	 * @return Layer
	 */
	public function setLegendService($legendService) {
		$this->legendService = $legendService;
		
		return $this;
	}

	/**
	 * Get legendService
	 *
	 * @return string
	 */
	public function getLegendService() {
		return $this->legendService;
	}

	/**
	 * Set detailService
	 *
	 * @param string $detailService        	
	 *
	 * @return Layer
	 */
	public function setDetailService($detailService) {
		$this->detailService = $detailService;
		
		return $this;
	}

	/**
	 * Get detailService
	 *
	 * @return string
	 */
	public function getDetailService() {
		return $this->detailService;
	}

	/**
	 * Set featureService
	 *
	 * @param string $featureService        	
	 *
	 * @return Layer
	 */
	public function setFeatureService($featureService) {
		$this->featureService = $featureService;
		
		return $this;
	}

	/**
	 * Get featureService
	 *
	 * @return string
	 */
	public function getFeatureService() {
		return $this->featureService;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string: JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->id,
			'name' => $this->name,
			'label' => $this->label,
			'serviceLayerName' => $this->serviceLayerName,
			'isTransparent' => $this->isTransparent,
			'defaultOpacity' => $this->defaultOpacity,
			'isBaseLayer' => $this->isBaseLayer,
			'isUntiled' => $this->isUntiled,
			'maxZoomLevel' => $this->maxZoomLevel,
			'minZoomLevel' => $this->minZoomLevel,
			'hasLegend' => $this->hasLegend,
			'providerId' => $this->providerId,
			'activateType' => $this->activateType,
			'viewServiceName' => $this->viewServiceName,
			'legendServiceName' => $this->legendServiceName,
			'detailServiceName' => $this->detailServiceName,
			'featureServiceName' => $this->featureServiceName
		];
	}
}
