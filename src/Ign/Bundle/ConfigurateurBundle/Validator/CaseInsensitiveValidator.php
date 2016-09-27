<?php
namespace Ign\Bundle\ConfigurateurBundle\Validator;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;
use Symfony\Component\HttpFoundation\RequestStack;
use Doctrine\ORM\EntityManagerInterface;

/**
 * Validator on the name attribute of the model
 */
class CaseInsensitiveValidator extends ConstraintValidator {

	private $em;

	/**
	 * The declared arguments comes from the service definition.
	 * They are saved to the object so the validate method can use them.
	 *
	 * @param EntityManagerInterface $em
	 */
	public function __construct(EntityManagerInterface $em) {
		$this->em = $em;
	}

	/**
	 * Throws a violation if the entity name already exists, whatever the case.
	 * This validation function is for entities of type Dataset and Model.
	 * It first handles the parameters depending on the type of the entity.
	 * Then checks if the entity already exists
	 * (it allow to check if the object is being created or is being edited).
	 * Finally throws a violation if the param already exists
	 */
	public function validate($entity, Constraint $constraint) {
		$class = (new \ReflectionClass($entity))->getShortName();
		$repository = $this->em->getRepository("IgnConfigurateurBundle:" . $class);

		switch ($class) {
			case 'Dataset':
				$param = 'label';
				$value = $entity->getLabel();
				break;
			case 'Model':
				$param = 'name';
				$value = $entity->getName();
		}

		$entityExistsQuery = $repository->createQueryBuilder('entity')
			->where('entity.id = :id')
			->setParameter('id', $entity->getId())
			->getQuery();

		if ($entityExistsQuery->execute()) {
			$labelExistsWithinAllExceptCurrentDatasetQuery = $repository->createQueryBuilder('entity')
				->where('upper(entity.' . $param . ') = upper(:value)')
				->andWhere('entity.id != :id')
				->setParameters(array(
				'value' => $value,
				'id' => $entity->getId()
			))
				->getQuery();

			if ($labelExistsWithinAllExceptCurrentDatasetQuery->execute()) {
				$this->context->addViolation($constraint->message);
			}
		} else {
			$labelExistsWithinAllQuery = $repository->createQueryBuilder('entity')
				->where('upper(entity.' . $param . ') = upper(:value)')
				->setParameter('value', $value)
				->getQuery();

			if ($labelExistsWithinAllQuery->execute()) {
				$this->context->addViolation($constraint->message);
			}
		}
	}
}