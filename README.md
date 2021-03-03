# install-scheduled-scaler-operator 설치 가이드
project repo: https://github.com/tmax-cloud/scheduled-scaler-operator

## Install (폐쇄망 X)
폐쇄망이 아닌 경우에는 상기한 project repo의 install guide를 참고합니다.

## Install (폐쇄망 구축 가이드)
### Prerequsite
   `kustomize` cli가 설치되지 않은 경우, `kustomize`를 설치합니다.

1. 외부 네트워크 통신이 가능한 환경에서 필요한 이미지를 다운받습니다.
    ```bash
    # 이미지 pull
    docker pull ghkimkor/scheduled-scaler

    # 이미지 save
    docker save ghkimkor/scheduled-scaler > scheduled-scaler.tar
    ```

2. 폐쇄망으로 이미지 압축파일(.tar)을 옮깁니다.
   
3. 폐쇄망에서 사용하는 registry에 이미지를 push 합니다.
    ```bash
    # 이미지 레지스트리 주소
    REGISTRY=[IP:PORT]

    # 이미지 Load
    docker load < scheduled-scaler.tar

    # 이미지 Tag
    docker tag ghkimkor/scheduled-scaler ${REGISTRY}/ghkimkor/scheduled-scaler

    # 이미지 Push
    docker push ${REGISTRY}/ghkimkor/scheduled-scaler

4. manifests/manager/kustomization.yaml 파일의 images의 newName 항목을 폐쇄망 레지스트리의 이미지로 설정합니다. 버전 태그를 변경한 경우, latest가 아닌 변경한 태그로 newTag 항목도 수정합니다.
   ```yaml
   resources:
    - manager.yaml
    apiVersion: kustomize.config.k8s.io/v1beta1
    kind: Kustomization
    images:
    - name: controller
      newName: ${REGISTRY}/ghkimkor/scheduled-scaler
      newTag: latest
   ```

5. `install.sh`를 실행합니다.
   ```bash
   bash install.sh
   ```

## Uninstall
1. `uninstall.sh`를 실행합니다.
   ```bash
   bash uninstall.sh
   ```

2. `uninstall.sh`의 실행이 종료되지 않고 멈춰있는 경우, 강제로 명령을 종료합니다. (ctrl + c)
   
3. `scheduled-scaler-operator-system` 네임스페이스가 종료 중 (terminating)인지 확인합니다.
   ```bash
   kubectl get namespace
   ```

4. 네임스페이스가 계속 종료되지 않는 경우, `remove_namespace.sh`를 실행하여 네임스페이스를 강제로 종료합니다.
   ```bash
   bash remove_namespace.sh
   ```