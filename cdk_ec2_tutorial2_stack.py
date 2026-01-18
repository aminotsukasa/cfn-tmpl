from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
)
from constructs import Construct

class CdkEc2Tutorial2Stack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # VPC作成
        vpc = self.create_vpc()
        # セキュリティグループの作成
        sg = self.create_security_group(vpc)

        # EC2インスタンス
        instance = ec2.Instance(self, "Instance",
            vpc=vpc,
            instance_type=ec2.InstanceType.of(ec2.InstanceClass.T3, ec2.InstanceSize.MICRO),
            machine_image=ec2.MachineImage.latest_amazon_linux2(),
            security_group=sg
        )

    # セキュリティグループを作成する
    def create_security_group(self, vpc: ec2.Vpc) -> ec2.SecurityGroup: 
        sg = ec2.SecurityGroup(self, "SecurityGroup",
            vpc=vpc,
            allow_all_outbound=True
        )
        sg.add_ingress_rule(ec2.Peer.any_ipv4(), ec2.Port.tcp(22), "SSH")


    # vpcを作成する
    def create_vpc(
        self,
        cidr: str = "10.0.0.0/16",
        max_azs: int = 2,
        vpc_name: str = "my-vpc"
    ) -> ec2.Vpc:

        vpc = ec2.Vpc(self, "VPC",
            max_azs=2,
            nat_gateways=0
        )
        return vpc

